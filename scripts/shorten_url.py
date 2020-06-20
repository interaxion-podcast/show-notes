import argparse
import json
import sys
import requests

def shorten_url(url, prefix, key):
    '''Firebase Dynamic Link を使って URL を短縮する'''
    post_url = 'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=' + key
    payload = {
        "longDynamicLink": "https://{}.page.link/?link={}".format(prefix, url),
        "suffix": {"option": "SHORT"}
    }
    headers = {'Content-type': 'application/json'}

    r = requests.post(post_url, data=json.dumps(payload), headers=headers)
    
    if not r.ok:
        print(str(r), file=sys.stderr)
        return None

    return json.loads(r.content)["shortLink"]
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("url", help="URL you'd like to shorten")
    parser.add_argument("prefix", help="xxxx of xxxx.page.link")
    parser.add_argument("key", help="API Key")
    args = parser.parse_args()

    print(shorten_url(args.url, args.prefix, args.key))

