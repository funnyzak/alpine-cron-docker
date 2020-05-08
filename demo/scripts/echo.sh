#!/bin/sh

source /utils.sh

date_str=$(date)

echo "$date_str" >> /db/echo.log

notify_all "echo script" "run"