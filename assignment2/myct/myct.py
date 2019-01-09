import os
import sys
import re
import subprocess

def init_container(parameters):
    container_path = parameters[0]
    os.system("mkdir -p %s" % container_path)
    os.system("debootstrap stable %s http://httpredir.debian.org/debian/" % container_path)
    os.system("mount --bind /proc %sproc && chroot %s apt -y --allow-unauthenticated install python" % (container_path, container_path))

def map_container(parameters):
    container_path = parameters[0]
    host_path = parameters[1]
    target_path = parameters[2]
    os.system("mkdir -p %s%s" % (container_path, target_path))
    os.system("mount --bind %s %s%s" % (host_path, container_path, target_path))
    os.system("mount -o bind,remount,ro %s%s" % (container_path, target_path))

def run_executable(container_path, namespaces, limits, executable, arguments):
    #print(container_path, namespaces, limits, executable, arguments)

    container_path_root = container_path.rstrip("/").split("/")[-1]
    unshare_options = set()
    nsenter_options = set()
    lookup = {
        "pid":"--pid",
        "uts":"--uts",
        "mnt":"--mnt",
        "ipc":"--ipc",
        "net":"--net",
        "cgroup":"--cgroup",
        "user":"--user"
    }

    if not namespaces:
        unshare_options.add("-f")
    else:
        nsenter_options.add("--mount=/proc/" + list(namespaces.items())[0][1] + "/ns/mnt")
        #   os.system("mount --bind /proc %sproc" % container_path)

    for key, value in namespaces.items():
        if not os.path.exists("/proc/" + value):
            raise SystemExit("PID does not exist.")
        
        if key == "mnt":
            nsenter_options.add("--mount=/proc/" + value + "/ns/" + key)
        else:
            nsenter_options.add(lookup[key] + "=/proc/" + value + "/ns/" + key)

    for key in lookup.keys() - namespaces.keys():
        if key == "mnt" and not namespaces:
            unshare_options.add("--mount-proc=%sproc" % container_path)
        elif key == "mnt":
            pass
        elif key == "user":
            unshare_options.add("-r")    
        else:
            unshare_options.add(lookup[key])

    limit_command_builder = []
    
    for key, value in limits.items():
        category, setting = key.split(".")
        limit_command_builder.append("mkdir -p /sys/fs/cgroup/%s/myct" % category)
        limit_command_builder.append('echo %s > /sys/fs/cgroup/%s/myct/%s.%s' % (value, category, category, setting))
        limit_command_builder.append('echo $$ > /sys/fs/cgroup/%s/myct/tasks' % category)

    limit_command = (" && ".join(limit_command_builder) + " && ") if limit_command_builder else ""
    nsenter_command = ("nsenter " + " ".join(nsenter_options)) if nsenter_options else ""
    unshare_command = "unshare " + " ".join(unshare_options)
    chroot_command = "chroot %s %s %s" % (container_path, executable, " ".join(arguments))
    #print(limit_command + nsenter_command + " " + unshare_command + " " + chroot_command)
    os.system(limit_command + nsenter_command + " " + unshare_command + " " + chroot_command)

def run_container(parameters):
    container_path = parameters.pop(0)
    namespaces = {}
    limits = {}
    while True:
        command = parameters.pop(0)
        if command == "--namespace":
            key, value = parameters.pop(0).split("=")
            namespaces[key] = value
        elif command == "--limit":
            key, value = parameters.pop(0).split("=")
            limits[key] = value
        else:
            run_executable(container_path, namespaces, limits, command, parameters)
            break
            
def main():
    if len(sys.argv) <= 1:
        raise SystemExit("Usage: python myct.py init|map|run <args...>")
    command = sys.argv[1]
    parameters = sys.argv[2:]
    if command == "init":
        if len(parameters) < 1:
            raise SystemExit("Usage: python myct.py init <container-path>")
        init_container(parameters)
    elif command == "map":
        if len(parameters) < 3:
            raise SystemExit("Usage: python myct.py map <container-path> <host-path> <target-path>")
        map_container(parameters)
    elif command == "run":
        if len(parameters) < 2:
            raise SystemExit("Usage: python myct.py run <container-path> [options] <executable> [args...]")
        run_container(parameters)
    else:
        raise SystemExit("Wrong argument!")
        
if __name__ == "__main__":
    main()