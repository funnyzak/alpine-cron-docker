#!/bin/bash
# author:funnyzak
# email:silenceace@gmail.com

# send notification to url 
function notify_url_single(){
    SCRIPT_NAME=$1
    ACTION_NAME=$2
    NOTIFY_URL=$3

    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. 【$NOTIFY_URL】Web Notify Notification Sending..."

    # current timestamp
    CURRENT_TS=$(date +%s)
    curl "$NOTIFY_URL" \
        -H "Content-Type: application/json" \
        -d "{
                \"_time\": \"$CURRENT_TS\",
                \"_name\": \"$APP_NAME\",
                \"_script\": \"$SCRIPT_NAME\",
                \"_action\": \"$ACTION_NAME\"
        }"
    curl -G "$NOTIFY_URL" \
        -d "_time=$CURRENT_TS&_name=$APP_NAME&_script=$SCRIPT_NAME&_action=$ACTION_NAME"

    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. 【$NOTIFY_URL】Web Notify Notification Sended."
}

# send notification to dingtalk
function dingtalk_notify_single() {
    SCRIPT_NAME=$1
    ACTION_NAME=$2
    TOKEN=$2
    
    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. DingTalk Notification Sending..."
    curl "https://oapi.dingtalk.com/robot/send?access_token=${TOKEN}" \
        -H "Content-Type: application/json" \
        -d '{
        "msgtype": "markdown",
        "markdown": {
            "title":"'"$APP_NAME $SCRIPT_NAME $ACTION_NAME"'.",
            "text": "#### 【'"$APP_NAME"'】 '" $SCRIPT_NAME $ACTION_NAME"'. \n\n"
        },
            "at": {
            "isAtAll": true
            }
        }'

    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. DingTalk Notification Sended."
}

# send notification to jishida
function jishida_notify_single() {
    SCRIPT_NAME=$1
    ACTION_NAME=$2
    TOKEN=$3

    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. JiShiDa Notification Sending..."
    curl --location --request POST "http://push.ijingniu.cn/send" \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data-urlencode "key=${TOKEN}" \
        --data-urlencode "head=${APP_NAME} ${SCRIPT_NAME} ${ACTION_NAME}." \
        --data-urlencode "body=${APP_NAME} ${SCRIPT_NAME} ${ACTION_NAME}."

    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. JiShiDa Notification Sended."
}

function ifttt_single() {
    SCRIPT_NAME=$1
    ACTION_NAME=$2
    NOTIFY_URL=$3

    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. 【$NOTIFY_URL】IFTTT Notify Notification Sended."
    curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"$APP_NAME\",\"value2\":\"$SCRIPT_NAME\",\"value3\":\"$ACTION_NAME\"}" "$NOTIFY_URL"
    echo "$APP_NAME $SCRIPT_NAME $ACTION_NAME. 【$NOTIFY_URL】IFTTT Notify Notification Sended."
}

# $4 url or token list
# $1 func name
# $2 script name
# $3 action
function notify_run(){
    if [ -n "$4" ]; then
        for item in ${4//|/ }
        do
            eval "$1 \"$2\" \"$3\" \"$item\""
        done
    fi
}

# notify all notify service
# $1 script name
# $2 action name
# eg: notify_all "数据库备份" "已开始" 
function notify_all(){
    notify_run "notify_url_single" "$1" "$2" "$NOTIFY_URL_LIST"
    notify_run "dingtalk_notify_single" "$1" "$2" "$DINGTALK_TOKEN_LIST"
    notify_run "jishida_notify_single" "$1" "$2" "$JISHIDA_TOKEN_LIST"
    notify_run "ifttt_single" "$1" "$2" "$IFTTT_HOOK_URL_LIST"
}

# checks if branch has something pending
parse_git_dirty() {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null
    [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
parse_git_branch() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
parse_git_hash() {
    git rev-parse --short HEAD 2>/dev/null | sed "s/\(.*\)/@\1/"
}

# get last commit message
parse_git_message() {
    git show --pretty=format:%s -s HEAD 2>/dev/null
}