import urllib.request
import sys
import time
import concurrent.futures
from statistics import median

def load_url(ip):
        url = "http://" + ip + "/file"
        urllib.request.urlopen(url).read()

def main():
    ip = sys.argv[1]
    start_all = time.time()
    measurements = []
    while time.time() - start_all < 10:
        start = time.time()
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            for i in range(10):
                executor.submit(load_url, ip)

        end = time.time()
        measurements.append(end-start)

    print(median(measurements))

if __name__ == '__main__':
        main()
