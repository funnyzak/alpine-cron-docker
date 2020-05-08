# docker-alpine-cron

Dockerfile and scripts for creating image with Cron based on Alpine  
Installed packages: dcron bash git zip unzip tar wget rsync ca-certificates curl mysql-client

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/alpine-cron.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/alpine-cron/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/alpine-cron.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/alpine-cron/)

This image is based on Alpine Linux image, which is a 27MB image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/alpine-cron.svg)](http://microbadger.com/images/funnyzak/alpine-cron)

[Docker hub image: funnyzak/alpine-cron](https://hub.docker.com/r/funnyzak/alpine-cron)

Docker Pull Command: `docker pull funnyzak/alpine-cron`

---

## Environment variables

CRON_STRINGS - strings with cron jobs. Use "\n" for newline (Default: undefined)

CRON_TAIL - if defined cron log file will read to *stdout* by *tail* (Default: undefined)

By default cron running in foreground  

---

## NOTIFY

You can use notifications by call "/utils.sh" in the execution script.

```bash
source /utils.sh

notify_all "db backup" "start"
```

### Notify Environment variables

* **NOTIFY_URL_LIST** : Optional. Notify link array , each separated by **|**
* **IFTTT_HOOK_URL_LIST** : Optional. ifttt webhook url array , each separated by **|** [Official Site](https://ifttt.com/maker_webhooks).
* **DINGTALK_TOKEN_LIST**: Optional. DingTalk Bot TokenList, each separated by **|** [Official Site](http://www.dingtalk.com).
* **JISHIDA_TOKEN_LIST**: Optional. JiShiDa TokenList, each separated by **|**. [Official Site](http://push.ijingniu.cn/admin/index/).
* **APP_NAME** : Optional. When setting notify, it is best to set.

---

## Cron files

* /etc/cron.d - place to mount custom crontab files  

When image will run, files in */etc/cron.d* will copied to */var/spool/cron/crontab*.

If *CRON_STRINGS* defined script creates file */var/spool/cron/crontab/CRON_STRINGS*  

---

## Log files

Log file by default placed in /var/log/cron/cron.log

---

## Simple usage

```docker
docker run --name="alpine-cron-sample" -d \
-v /path/to/app/conf/crontabs:/etc/cron.d \
-v /path/to/app/scripts:/scripts \
xordiv/docker-alpine-cron
```

---

## With scripts and CRON_STRINGS

```docker
docker run --name="alpine-cron-sample" -d \
-e 'CRON_STRINGS=* * * * * /scripts/myapp-script.sh'
-v /path/to/app/scripts:/scripts \
xordiv/docker-alpine-cron
```

---

## Get URL by cron every minute

``` docker
docker run --name="alpine-cron-sample" -d \
-e 'CRON_STRINGS=* * * * * wget --spider https://sample.dockerhost/cron-jobs'
xordiv/docker-alpine-cron
```

---

## Docker-compose

```docker
version: '3'
services:
  acron:
    image: funnyzak/alpine-cron
    privileged: true
    container_name: cron
    logging:
      driver: 'json-file'
      options:
        max-size: '1g'
    tty: true
    environment:
      - TZ=Asia/Shanghai
      - LANG=C.UTF-8
      - CRON_TAIL=1
      - CRON_STRINGS=* * * * * /scripts/echo.sh
      - APP_NAME=MyApp
      - JISHIDA_TOKEN_LIST=jishidatoken
      - NOTIFY_URL_LIST=http://link1.com/notify1|http://link2.com/notify2
      - DINGTALK_TOKEN_LIST=dingtalktoken1|dingtalktoken2
      - IFTTT_HOOK_URL_LIST=https://maker.ifttt.com/trigger/cron_notify/with/key/ifttttoken-s3Up
    restart: on-failure
    volumes:
      - ./scripts:/scripts # execute script
      - ./cron:/etc/cron.d # crontab
      - ./db:/db # log
```

For more information, please see the "Demo" folder.