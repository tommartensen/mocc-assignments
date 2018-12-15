FROM ubuntu

RUN apt-get update && apt-get install -y gcc bc

COPY linpack.c .
COPY measure-cpu.sh .

CMD echo "$(sh measure-cpu.sh)"
