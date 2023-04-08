FROM golang:1.19-alpine AS builder

COPY . /app

WORKDIR /app/backend

# Add gcc
RUN apk add build-base

RUN go get -v . && \
    go env -w GOFLAGS=-mod=mod && \
    go build -v .

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/backend/backend ./backend

EXPOSE 80
CMD [ "./backend", "--postgres", "postgres" ]
