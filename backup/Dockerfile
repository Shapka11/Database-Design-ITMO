FROM alpine:latest

RUN apk add --no-cache \
    bash \
    curl \
    postgresql-client \
    dcron \
    busybox-extras

RUN curl -L https://dl.min.io/client/mc/release/linux-amd64/mc \
    -o /usr/bin/mc \
    && chmod +x /usr/bin/mc

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]