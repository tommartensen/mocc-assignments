FROM alpine

RUN apk add build-base

COPY linpack.c .
COPY measure-cpu.sh .

CMD echo "$(sh measure-cpu.sh)"
