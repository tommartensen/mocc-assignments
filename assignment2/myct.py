import os
import sys
import re

def init_container(parameters):
    container_path = parameters[0]
    os.system("mkdir -p %s" % container_path)
    os.system("debootstrap stable %s http://httpredir.debian.org/debian/" % container_path)

def map_container(parameters):
    container_path = parameters[0]
    host_path = parameters[1]
    target_path = parameters[2]
    os.system("mkdir -p %s%s" % (container_path, target_path))
    os.system("mount --bind %s %s%s" % (host_path, container_path, target_path))
    os.system("mount -o bind,remount,ro %s%s" % (container_path, target_path))

def run_executable(container_path, namespaces, limits, executable, arguments):
    print(container_path, namespaces, limits, executable, arguments)

    container_path_root = container_path.rstrip("/").split("/")[-1]
    unshare_options = ""
    nsenter_options = ""
    lookup = {
        "pid":"--pid",
        "uts":"--uts",
        "mount":"--mnt",
        "ipc":"--ipc",
        "net":"--net",
        "cgroup":"--cgroup",
        "user":"--user"
    }

    for key, value in namespaces.items():
        if not os.path.exists("/proc/" + value):
            raise SystemExit("PID does not exist.")

        #unshare_options += lookup[key] + "=/proc/" + value + "/ns/" + key + " "
        nsenter_options += lookup[key] + "=/proc/" + value + "/ns/" + key + " "

    nsenter_command = "nsenter " + nsenter_options if nsenter_options else ""
    unshare_command = " unshare " + unshare_options + " -f --mount-proc=%sproc " % container_path
    print(nsenter_command)
    #os.system(nsenter_command)
    print(unshare_command)
    os.system(nsenter_command + unshare_command + " chroot  %s %s %s" % (container_path, executable, " ".join(arguments)))

    #os.system()
def run_container(parameters):
    print(parameters)
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
        raise SystemExit("No arguments.")
    command = sys.argv[1]
    parameters = sys.argv[2:]
    if command == "init":
        init_container(parameters)
    elif command == "map":
        map_container(parameters)
    elif command == "run":
        run_container(parameters)
    else:
        raise SystemExit("Wrong argument!")
        
if __name__ == "__main__":
    main()