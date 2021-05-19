#!/bin/bash

source tokens.sh

useragent="user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"

links=($(curl -s https://raw.githubusercontent.com/drushadrusha/awesome-maps/main/readme.md | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%&:-]*"))
for link in "${links[@]}"
do
    if [ "$link" == "https://planefinder.net/" ];then
        echo "$link does not like being curl'ed :(. Skipping..."
        continue
    fi

    if curl -H "$useragent" -sL -k -w "%{http_code}\\n" "$link" | grep "200" > /dev/null; then 
        echo "$link is UP"
    else
        echo "$link is DOWN. I'm gonna create github issue..."
        curl -X POST -u drushadrusha:"$githubToken" https://api.github.com/repos/drushadrusha/awesome-maps/issues   -d '{"title":"'$link' is down."}'
        curl "https://api.telegram.org/bot$telegramBotToken/sendMessage?chat_id=$telegramChatId&text=awesome-maps checker:%0A$link is down."
    fi
done