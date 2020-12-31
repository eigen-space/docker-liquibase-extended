FROM liquibase/liquibase:4.1

USER root
RUN apt-get update \
    && apt-get -y install git \
    && git --version

USER liquibase

COPY --chown=liquibase:liquibase bin/entrypoint.sh /scripts/extended-entrypoint.sh

RUN chmod +x /scripts/extended-entrypoint.sh

ENTRYPOINT ["/scripts/extended-entrypoint.sh"]
CMD ["--help"]