import urllib.request
import sys
import time
import concurrent.futures

def load_url(ip):
        url = "http://" + ip + "/file"
        urllib.request.urlretrieve(url)

def main():
        ip = sys.argv[1]
        start = time.time()

        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
                for i in range(2):
                        executor.submit(load_url, ip)

        end = time.time()

        print(end-start)

if __name__ == '__main__':
        main()
