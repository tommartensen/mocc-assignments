FROM nginx

RUN dd if=/dev/urandom of=/usr/share/nginx/html/file bs=10M count=51