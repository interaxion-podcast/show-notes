# コードを実行するコンテナイメージ
FROM pandoc/latex:2.6

# アクションのリポジトリからコードファイルをファイルシステムパスへコピー
COPY entrypoint.sh /entrypoint.sh

# dockerコンテナが起動する際に実行されるコードファイル (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
