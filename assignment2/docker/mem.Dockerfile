FROM alpine

RUN apk add build-base

COPY memsweep.c .
COPY measure-mem.sh .

CMD echo "$(sh measure-mem.sh)"
