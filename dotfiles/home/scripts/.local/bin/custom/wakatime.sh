#!/bin/sh
TOKEN="waka_38026902-95ea-42c9-9452-81699cfb6d4a"

wakatime_today="$(curl -sf --header "Authorization: Basic $(echo "$TOKEN" | base64)" https://wakatime.com/api/v1/users/current/status_bar/today | jq -r '.data.grand_total.text')"

if [ -n "$wakatime_today" ]; then
	echo "$wakatime_today"
else
	echo ""
fi
