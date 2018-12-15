FROM ubuntu

RUN apt-get update && apt-get install -y gcc bc

COPY memsweep.c .
COPY measure-mem.sh .

CMD echo "$(sh measure-mem.sh)"
