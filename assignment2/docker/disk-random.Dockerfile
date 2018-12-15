FROM ubuntu

RUN apt-get update && apt-get install -y fio bc

COPY measure-disk-random.sh .

CMD echo "$(sh measure-disk-random.sh)"
