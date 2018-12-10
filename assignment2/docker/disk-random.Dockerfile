FROM alpine

# fio installation, based on https://hub.docker.com/r/dmonakhov/alpine-fio/~/dockerfile/
# Purposely not extending his Dockerfile, since the last build was 2 years ago.
RUN apk --no-cache add \
	bc \
	make \
	alpine-sdk \
	zlib-dev \
	libaio-dev \
	linux-headers \
	coreutils \
	libaio && \
    git clone https://github.com/axboe/fio && \
    cd fio && \
    ./configure && \
    make -j`nproc` && \
    make install && \
    cd .. && \
    rm -rf fio && \
    apk --no-cache del \
	make \
	alpine-sdk \
	zlib-dev \
	libaio-dev \
	linux-headers \
	coreutils

COPY measure-disk-random.sh .

CMD echo "$(sh measure-disk-random.sh)"
