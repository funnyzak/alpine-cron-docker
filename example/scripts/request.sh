#!/bin/bash

source /utils.sh

curl -X POST -d "fizz=buzz" https://www.baidu.com

notify_all "request script" "run"