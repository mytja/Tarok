FROM debian:bullseye

WORKDIR /app
COPY . /app

RUN "ls"

EXPOSE 80
CMD [ "./backend", "--pghost", "postgres" ]
