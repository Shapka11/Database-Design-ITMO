FROM liquibase/liquibase:4.25

USER root

RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://realkarych.github.io/seqwall-apt/public.key | tee /etc/apt/trusted.gpg.d/seqwall.asc \
    && echo "deb [arch=$(dpkg --print-architecture)] https://realkarych.github.io/seqwall-apt stable main" | tee /etc/apt/sources.list.d/seqwall.list \
    && apt-get update \
    && apt-get install -y seqwall

COPY scripts /scripts
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /scripts/*.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]