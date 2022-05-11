FROM postgres

RUN apt-get update && apt-get install -y python

COPY postgres-pinger.sh .

CMD "./postgres-pinger.sh"
