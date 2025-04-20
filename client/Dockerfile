FROM alpine:3.21

RUN apk add --no-cache bash postgresql-client

RUN addgroup -g 1000 app && adduser -u 1000 -G app -s /bin/sh -D app

COPY ./client.sh /usr/local/bin/client
RUN chmod 555 /usr/local/bin/client

COPY demo.sh /usr/local/bin/demo
RUN chmod 555 /usr/local/bin/demo

WORKDIR /app

RUN chown app:app /app

USER app