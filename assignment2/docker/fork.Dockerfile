FROM alpine

RUN apk add build-base

COPY forksum.c .
COPY measure-fork.sh .

CMD echo "$(sh measure-fork.sh)"
