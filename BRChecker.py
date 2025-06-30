import webbrowser as wb
from platform import system
from datetime import date
from time import sleep

import requests as req
from pyclip import copy


def get_date_format():
    return "%B-%#d-%Y" if system() == "Windows" else "%B-%-d-%Y"


def check_urls(urls):
    for url in urls:
        print(f"Checking: {url}")
        try:
            response = req.head(url, timeout=5).status_code
            if response == 200:
                print(f"{response}: It's up!")
                return url
            elif response == 502:
                print(f"{response}: Going up soon.")
            elif response in [403, 404]:
                print(f"{response}: Not up yet.")
            else:
                print(f"{response}: Unexpected response code")
        except req.exceptions.RequestException as e:
            print(f"Error on {url}: {e}")
        sleep(0.25)
    return None


def main():
    br_date = date.today().strftime(get_date_format()).lower()
    base_url = "https://magic.wizards.com/en/news/announcements"
    urls = [
        f"{base_url}/banned-and-restricted-{br_date}",
        f"{base_url}/{br_date}-banned-and-restricted",
        f"{base_url}/banned-and-restricted-announcement-{br_date}",
        f"{base_url}/{br_date}-banned-and-restricted-announcement",
    ]

    found_url = None
    while not found_url:
        found_url = check_urls(urls)
    wb.open_new_tab(found_url)
    copy(found_url)


if __name__ == "__main__":
    main()
