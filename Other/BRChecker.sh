#!/usr/bin/bash

test_urls() {
    for url in ${urls[@]}; do
        response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$url")
        if [[ $response == 200 ]]; then
            echo "$response: It's up!"
            xdg-open $url
            echo $url | wl-copy
            found_url="true"
        else
            echo "$response: Not up yet."
        fi
        sleep 1
    done
}

br_date=$(date +"%B-%-d-%Y"); br_date=${br_date,,}
base_url="https://magic.wizards.com/en/news/announcements"
urls=(
    "$base_url/banned-and-restricted-$br_date"
    "$base_url/$br_date-banned-and-restricted"
    "$base_url/banned-and-restricted-announcement-$br_date"
    "$base_url/$br_date-banned-and-restricted-announcement"
)

found_url="false"
while [[ $found_url != "true" ]]; do
    test_urls
done
