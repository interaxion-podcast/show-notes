import argparse
import json
import re
import requests
from shorten_url import shorten_url

def shorten_urls_md(mdfile, prefix, key):
    # () を除く、文字、数字、記号の連続を URL とみなす
    pattern = re.compile("(http|https)://[\w/0-9:%#\$\&\?~\.=\+\-\_]+")
    with open(mdfile) as f:
        newlines = []
        for line in f.readlines():
            m = re.search(pattern, line)
            if m is None:
                newlines.append(line)
                continue
            org_url = line[m.span()[0]:m.span()[1]]

            if "amzn" in org_url or "page.link" in org_url or "scrapbox" in org_url or len(org_url) < len("https://i8n.page.link/xxxx"):
                # amzn は短縮しない
                # 短縮済みを skip
                # scrapbox は短縮しない
                # 元々短いものを skip
                newlines.append(line)
                continue

            short_url = shorten_url(org_url, prefix, key)
            if short_url is not None:
                line = line.replace(org_url, short_url)
            newlines.append(line)
        return ''.join(newlines)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("mdfile", help="Markdown file name")
    parser.add_argument("prefix", help="xxxx of xxxx.page.link")
    parser.add_argument("key", help="API Key")
    args = parser.parse_args()

    print(shorten_urls_md(args.mdfile, args.prefix, args.key), end='')
