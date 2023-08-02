FROM golang:1.20-bullseye AS backend

COPY . /app

WORKDIR /app/backend

# Add gcc
RUN apt update && apt install -y build-essential

RUN go get -v . && \
    go env -w GOFLAGS=-mod=mod && \
    go build -v .

FROM dart:latest AS stockskis

COPY . /app

WORKDIR /app/stockskis_cli

RUN dart pub get && ./build.sh

FROM debian:bullseye

WORKDIR /app
COPY --from=backend /app/backend/backend ./backend
COPY --from=stockskis /app/backend/stockskis ./stockskis

EXPOSE 80
CMD [ "./backend", "--pghost", "postgres" ]
