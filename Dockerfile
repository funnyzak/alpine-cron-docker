FROM funnyzak/alpine-glibc

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="Alpine Cron" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Alpine CRON." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.schema-version="1.0"	\
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/alpine-cron-docker" 

ENV LANG=C.UTF-8
 
RUN apk update && apk upgrade && \
    apk add --no-cache dcron \
    ca-certificates bash curl wget rsync git gcc openssh make cmake zip unzip gzip bzip2 tar tzdata && \
    rm  -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /var/log/cron && \
    mkdir /scripts && \
    mkdir -m 0644 -p /var/spool/cron/crontabs && \
    touch /var/log/cron/cron.log && \
    mkdir -m 0644 -p /etc/cron.d

COPY /scripts/* /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]

