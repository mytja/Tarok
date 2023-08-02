FROM debian:bullseye

WORKDIR /app
COPY . /app

EXPOSE 80
CMD [ "./backend", "--pghost", "postgres" ]
