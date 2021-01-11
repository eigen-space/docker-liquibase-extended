FROM liquibase/liquibase:4.1

USER root
RUN apt-get update \
    && apt-get --no-install-recommends -y install git=1:2.20.1-2+deb10u3 \
    && rm -rf /var/lib/apt/lists/*

USER liquibase

COPY --chown=liquibase:liquibase bin/entrypoint.sh /scripts/extended-entrypoint.sh

RUN chmod +x /scripts/extended-entrypoint.sh

ENTRYPOINT ["/scripts/extended-entrypoint.sh"]
CMD ["--help"]