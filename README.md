# docker-alpine-cron

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/alpine-cron.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/alpine-cron/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/alpine-cron.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/alpine-cron/)

Dockerfile and scripts for creating image with Cron based on Alpine  
Installed packages: dcron ca-certificates bash curl wget rsync git zip unzip gzip bzip2 tar tzdata mysql-client

This image is based on Alpine Linux image, which is a 90MB image.

Download size of this image is:

[![Image Size](https://img.shields.io/docker/image-size/funnyzak/alpine-cron)](https://hub.docker.com/r/funnyzak/alpine-cron/)

[Docker hub image: funnyzak/alpine-cron](https://hub.docker.com/r/funnyzak/alpine-cron)

Docker Pull Command: `docker pull funnyzak/alpine-cron`

## Environment variables

CRON_STRINGS - strings with cron jobs. Use "\n" for newline (Default: undefined)

CRON_TAIL - if defined cron log file will read to *stdout* by *tail* (Default: undefined)

By default cron running in foreground.

## Installed packages

The following packages are installed by default:

- certificates
- bash
- curl
- wget
- rsync
- git
- gcc
- openssh
- make
- cmake
- zip
- unzip
- gzip
- certbot
- bzip2
- tar
- tzdata
- mysql-client
- mariadb-connector-c
- ossutil64

## NOTIFY

You can use notifications by call "/utils.sh" in the execution script.

```bash
source /utils.sh

notify_all "db backup" "start"
```

### Notify Environment variables

- **NOTIFY_URL_LIST** : Optional. Notify link array , each separated by **|**
- **TELEGRAM_BOT_TOKEN**: Optional. telegram Bot Token-chatid setting. eg: **token###chatid|token2###chatid2**. each separated by **|** [Official Site](https://core.telegram.org/api).
- **IFTTT_HOOK_URL_LIST** : Optional. ifttt webhook url array , each separated by **|** [Official Site](https://ifttt.com/maker_webhooks).
- **DINGTALK_TOKEN_LIST**: Optional. DingTalk Bot TokenList, each separated by **|** [Official Site](http://www.dingtalk.com).
- **JISHIDA_TOKEN_LIST**: Optional. JiShiDa TokenList, each separated by **|**. [Official Site](http://push.ijingniu.cn/admin/index/).
- **APP_NAME** : Optional. When setting notify, it is best to set.

---

## Cron files

- /etc/cron.d - place to mount custom crontab files  

When image will run, files in */etc/cron.d* will copied to */var/spool/cron/crontab*.

If *CRON_STRINGS* defined script creates file */var/spool/cron/crontab/CRON_STRINGS*  

## Log files

Log file by default placed in /var/log/cron/cron.log

## Simple usage

```bash
docker run --name="alpine-cron-sample" -d \
-v /path/to/app/conf/crontabs:/etc/cron.d \
-v /path/to/app/scripts:/scripts \
funnyzak/alpine-cron
```

## With scripts and CRON_STRINGS

```bash
docker run --name="alpine-cron-sample" -d \
-e 'CRON_STRINGS=* * * * * /scripts/myapp-script.sh'
-v /path/to/app/scripts:/scripts \
funnyzak/alpine-cron
```

## Get URL by cron every minute

```bash
docker run --name="alpine-cron-sample" -d \
-e 'CRON_STRINGS=* * * * * wget --spider https://sample.dockerhost/cron-jobs'
funnyzak/alpine-cron
```

---

## Docker-compose

```yaml
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
      - CRON_TAIL=1 # tail cron log
      - CRON_STRINGS=* * * * * /scripts/echo.sh
      - APP_NAME=MyApp
      - JISHIDA_TOKEN_LIST=jishidatoken
      - NOTIFY_URL_LIST=http://link1.com/notify1|http://link2.com/notify2
      - TELEGRAM_BOT_TOKEN=123456789:SDFW33-CbovPM2TeHFCiPUDTLy1uYmN04I###9865678987
      - DINGTALK_TOKEN_LIST=dingtalktoken1|dingtalktoken2
      - IFTTT_HOOK_URL_LIST=https://maker.ifttt.com/trigger/cron_notify/with/key/ifttttoken-s3Up
    restart: on-failure
    volumes:
      - ./scripts:/scripts # execute script
      - ./cron:/etc/cron.d # crontab
      - ./db:/db # log
```

For more information, please see the "Demo" folder.

## Contribution

If you have any questions or suggestions, please feel free to submit an issue or pull request.

<a href="https://github.com/funnyzak/vue-starter/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=funnyzak/vue-starter" />
</a>

## License

MIT License © 2022 [funnyzak](https://github.com/funnyzak)
