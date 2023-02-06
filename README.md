# docker-alpine-cron

[![Build Status][build-status-image]][build-status]
[![Docker Stars][docker-star-image]][repository-url]
[![Docker Pulls][docker-pull-image]][repository-url]
[![GitHub release (latest by date)][latest-release]][repository-url]
[![GitHub][license-image]][repository-url]

A lightweight Docker image with Cron based on Alpine Linux.

Download size of this image is only:

[![Image Size][docker-image-size]][docker-hub-url]

[Docker hub image: funnyzak/alpine-cron][docker-hub-url]

**Docker Pull Command**: `docker pull funnyzak/alpine-cron:latest`

## Environment variables

- **CRON_STRINGS**: Strings with cron jobs. Use "\n" for newline (Default: undefined)

- **CRON_TAIL**: - If defined cron log file will read to *stdout* by *tail* (Default: undefined)

By default cron running in foreground.

## Packages

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
- nodejs
- yarn
- npm
- pushoo-cli
- mysql-client
- mariadb-connector-c
- ossutil64

## Cron files

- **/etc/cron.d** Place to mount custom crontab files  

When image will run, files in */etc/cron.d* will copied to */var/spool/cron/crontab*.

If *CRON_STRINGS* defined script creates file */var/spool/cron/crontab/CRON_STRINGS*  

## Logs

Log file by default placed in /var/log/cron/cron.log

## Notification

The image already installed [pushoo-cli](https://github.com/funnyzak/pushoo-cli), you can use it to send notification. You can send notification to DingTalk, iFttt, Discord, Feishu, atri, bark, etc.

More information about pushoo-cli, please refer to [pushoo-cli](https://github.com/funnyzak/pushoo-cli) and [pushoo](https://github.com/imaegoo/pushoo).

## Usage

### One Cron job

```bash
docker run --name="alpine-cron-sample" -d \
-v /path/to/app/conf/crontabs:/etc/cron.d \
-v /path/to/app/scripts:/scripts \
funnyzak/alpine-cron
```

### With scripts and CRON_STRINGS

```bash
docker run --name="alpine-cron-sample" -d \
-e 'CRON_STRINGS=* * * * * /scripts/myapp-script.sh'
-v /path/to/app/scripts:/scripts \
funnyzak/alpine-cron
```

### Get URL by cron every minute

```bash
docker run --name="alpine-cron-sample" -d \
-e 'CRON_STRINGS=* * * * * wget --spider https://sample.dockerhost/cron-jobs'
funnyzak/alpine-cron
```

---

### Compose

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
    restart: on-failure
    volumes:
      - ./scripts:/scripts # execute script
      - ./cron:/etc/cron.d # crontab
      - ./db:/db # log
```

For more details, please refer to the [docker-compose.yml](example/docker-compose.yml) file.

## Contribution

If you have any questions or suggestions, please feel free to submit an issue or pull request.

<a href="https://github.com/funnyzak/vue-starter/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=funnyzak/alpine-cron-docker" />
</a>

## License

MIT License © 2022 [funnyzak](https://github.com/funnyzak)

[build-status-image]: https://github.com/funnyzak/alpine-cron-docker/actions/workflows/build.yml/badge.svg
[build-status]: https://github.com/funnyzak/alpine-cron-docker/actions
[repository-url]: https://github.com/funnyzak/alpine-cron-docker
[license-image]: https://img.shields.io/github/license/funnyzak/alpine-cron-docker?style=flat-square&logo=github&logoColor=white&label=license
[latest-release]: https://img.shields.io/github/v/release/funnyzak/alpine-cron-docker
[docker-star-image]: https://img.shields.io/docker/stars/funnyzak/alpine-cron.svg?style=flat-square
[docker-pull-image]: https://img.shields.io/docker/pulls/funnyzak/alpine-cron.svg?style=flat-square
[docker-image-size]: https://img.shields.io/docker/image-size/funnyzak/alpine-cron
[docker-hub-url]: https://hub.docker.com/r/funnyzak/alpine-cron
