# Postgres Pinger

Create a docker image that I can deploy to AWS ECS to confirm whether the
container can access an AWS RDS postgresql database.

## Start a postgresql server

```
docker network create -d bridge postgres-net
docker run --rm --network postgres-net --name db-server \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydb \
  postgres
```

## Start a client

> URL for connection:
>     postgresql://[user[:password]@][netloc][:port][,...][/dbname][?param1=value1&...]
> Connecting using psql:
>     psql -h db-server -d mydb -U myuser

```
docker run --rm --network postgres-net --name pg-client \
  -e DATABASE_URL=postgresql://myuser:mysecretpassword@db-server:5432/mydb \
  -it postgres sh

psql $DATABASE_URL -c 'select now();'
              now
-------------------------------
 2022-05-11 03:07:37.803734+00
(1 row)
```

## Run a pinger

```
make build

docker run --rm --name postgres-pinger --network postgres-net \
  -e PORT=3000 \
  -e DATABASE_URL=postgresql://myuser:mysecretpassword@db-server:5432/mydb \
  -it postgres-pinger
```

## Cleanup

```
docker network rm postgres-net
```
