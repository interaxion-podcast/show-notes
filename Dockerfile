# コードを実行するコンテナイメージ
FROM pandoc/latex:2.6

RUN apk --update-cache add \
        python3 \
        python3-dev && \
    pip3 install requests

# アクションのリポジトリからコードファイルをファイルシステムパスへコピー
COPY entrypoint.sh /entrypoint.sh
COPY scripts/shorten_url.py /shorten_url.py
COPY scripts/shorten_urls_md.py /shorten_urls_md.py

# dockerコンテナが起動する際に実行されるコードファイル (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
