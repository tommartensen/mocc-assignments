f = open("/dev/urandom", "r")
data = []

i=0
while True:
    data.append(f.read(1000000)) # 1mb
    i += 1
    print "%dmb" % i