# コードを実行するコンテナイメージ
FROM pandoc/latex:2.6

RUN apk --update-cache add \
        python3 \
        python3-dev && \
    pip3 install requests

# アクションのリポジトリからコードファイルをファイルシステムパスへコピー
COPY entrypoint.sh /entrypoint.sh

# dockerコンテナが起動する際に実行されるコードファイル (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
