#!/bin/sh
TOKEN="waka_9bc083cc-f124-458b-a173-2b1112deb3bc"

wakatime_today="$(curl -sf --header "Authorization: Basic $(echo "$TOKEN" | base64)" https://wakatime.com/api/v1/users/current/status_bar/today | jq -r '.data.grand_total.text')"

if [ -n "$wakatime_today" ]; then
    echo "$wakatime_today"
else
    echo ""
fi
