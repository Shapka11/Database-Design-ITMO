FROM postgres:18

RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-psycopg2 curl jq iproute2 gosu && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages patroni[etcd3]

COPY patroni.yaml /etc/patroni/patroni.yaml
COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]