import urllib.request
import sys
import time
import concurrent.futures

def load_url(url):
	urllib.request.urlretrieve(url)

def main():
	url = sys.argv[1]
	start = time.time()

	with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
		for i in range(2):
			executor.submit(load_url, url)

	end = time.time()

	print(end-start)

if __name__ == '__main__':
	main()