FROM golang:latest-alpine AS builder

COPY . /app

WORKDIR /app

# Add gcc
RUN apk add build-base

RUN go mod download && \
    go env -w GOFLAGS=-mod=mod && \
    go build -v .

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/backend ./backend

EXPOSE 80
CMD [ "./backend" ]
