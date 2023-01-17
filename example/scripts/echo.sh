#!/bin/bash

source /utils.sh

date_str=$(date)

echo "$date_str" >> /logs/echo.log

notify_all "echo script" "run"