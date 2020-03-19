# コードを実行するコンテナイメージ
FROM maxheld83/pandoc@v2

# アクションのリポジトリからコードファイルをファイルシステムパスへコピー
`/` of the container
COPY entrypoint.sh /entrypoint.sh

# dockerコンテナが起動する際に実行されるコードファイル (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
