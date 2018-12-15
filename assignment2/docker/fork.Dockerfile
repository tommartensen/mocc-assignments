FROM ubuntu

RUN apt-get update && apt-get install -y gcc bc

COPY forksum.c .
COPY measure-fork.sh .

CMD echo "$(sh measure-fork.sh)"
