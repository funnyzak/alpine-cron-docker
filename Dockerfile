FROM funnyzak/alpine-glibc

ARG BUILD_DATE
ARG VCS_REF

ENV TZ Asia/Shanghai
ENV LC_ALL C.UTF-8
ENV LANG=C.UTF-8
ENV OSSUTIL_VERSION=1.7.14

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="Alpine Cron" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Alpine CRON." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.schema-version="1.0.1"	\
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/alpine-cron-docker" 


RUN apk update && apk upgrade && \
    apk add --no-cache dcron certbot \
    ca-certificates bash curl wget rsync git gcc rclone openssh make cmake zip unzip gzip bzip2 tar tzdata mysql-client mariadb-connector-c && \
    rm  -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /var/log/cron && \
    mkdir /scripts && \
    mkdir -m 0644 -p /var/spool/cron/crontabs && \
    touch /var/log/cron/cron.log && \
    mkdir -m 0644 -p /etc/cron.d

# ossutil64
RUN curl -Lo /opt/ossutil http://gosspublic.alicdn.com/ossutil/$OSSUTIL_VERSION/ossutil64          
RUN chmod 755 /opt/ossutil
RUN ln -s /opt/ossutil /usr/local/bin
ENV PATH /usr/local/bin/ossutil:$PATH

COPY /scripts/* /run_scripts/
COPY /scripts/utils.sh /utils.sh

RUN chmod +x -R /run_scripts
RUN chmod +x -R /utils.sh

ENTRYPOINT ["/run_scripts/entrypoint.sh"]
CMD ["/run_scripts/cmd.sh"]

