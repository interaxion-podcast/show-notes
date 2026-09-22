# CLAUDE.md

エージェントがこのリポジトリで作業するときの参考メモ。

## このリポジトリの位置づけ

Show Notes は2箇所にある。

| | 場所 | 役割 |
|---|---|---|
| 完全版 | `interaxion-podcast/interaxion-podcast.github.io` の `_posts/<年>/<YYYY-MM-DD>-ep<N>.md` | 主にメンテするのはこちら。YouTube/Twitter 埋め込みあり |
| 簡易版 | このリポジトリの `md/ep<N>.md` | 完全版から抜粋して作る。podcast の RSS feed 用 |

**簡易版はゼロから書かない。必ず完全版から抜粋する。** 完全版がまだ無い場合は、先にそちらを作るべきかを確認すること。

## 完全版 → 簡易版 の変換ルール

ep66 / ep67 / ep64 が最近の見本。

落とすもの:

- front matter 全体
- 目次の `<details>` ブロック
- ツイート埋め込み (`<blockquote class="twitter-tweet">` と後続の `<script>`)
- Audiostock などの `<iframe>`

足す・書き換えるもの:

- 1行目を `# Ep. <N> <front matter の title のコロン以降>`
- front matter の `excerpt` を導入文にし、続けて
  `以下の Show Notes は簡易版です。完全版は[こちら](https://interaxion-podcast.github.io/<N>)`
  （末尾の `。` は ep63/ep64 では付いていたが ep66/ep67 では付いていない。新しい方に揃える）
- 訂正がある場合は導入文の直後に1行足す (ep64, ep68 の前例)
- お知らせ欄の出演募集は、完全版の「出演して頂ける方や感想などをお待ちしております！」を
  `[出演して頂ける方、感想などお待ちしております](https://interaxion-podcast.github.io/feedback/)。 [#interaxion](https://twitter.com/hashtag/interaxion)`
  に置き換える

見出し (`### 0:00 ...`) とリンク項目は完全版のものをそのまま維持する。作業後は完全版との
リンク差分を取り、意図した増減だけになっているか確認すること。

書式の細かい点:

- 改行したい行末には**半角スペース2個**を置く（導入文、リンクの補足行など）
- リンクの補足行はスペース2個 + 改行の後、2スペースインデントで書く

## HTML は 4000 文字以内

`md/*.md` は GitHub Actions (`entrypoint.sh`) が pandoc で `html/ep<N>.html` に変換する。
この HTML を Anchor の RSS に載せる都合上、**4000文字以内**に収める必要がある。

バイト数ではなく**文字数**。既存 77 ファイルのうち 4000 バイト超は 61 個あるのに対し、
4000 文字超は 11 個だけで、しかも 4019 / 4026 / 4068 と 4000 のすぐ上に固まっている
（上限ぎりぎりまで削った跡）。日本語が多いのでバイトで測ると実態より2〜3割大きく出る。

### 事前確認のしかた

CI を待たずにローカルで確認できる。`entrypoint.sh` と同じ処理を再現する:

```sh
pip3 install pypandoc_binary   # 環境に pandoc が無い場合
python3 - <<'PY'
import pypandoc
out = pypandoc.convert_file('md/ep68.md', 'html', format='markdown-auto_identifiers',
                            extra_args=['--wrap=none']).replace('\n', '')
print(len(out), 'chars', '=> OK' if len(out) <= 4000 else '=> OVER')
PY
```

**`--wrap=none` が必須。** Action は pandoc 2.6 を使っていて折り返さないが、新しい pandoc は
デフォルトで 72 桁に折り返すため、`tr -d '\n'` した際に空白が消えて数十文字ずれる。
`--wrap=none` を付ければ ep61 / ep63 / ep64 / ep66 / ep67 の成果物とバイト単位で完全一致する。

文字数を数えるときは `wc -m` を使わないこと。ロケール次第でバイト数が返る。Python の `len()` が確実。

## 触らないファイル

`html/*.html` と `chapters/episodes.yml` は GitHub Actions が生成してコミットする。手で編集しない。

なお `html/ep60.html` / `ep62.html` / `ep65.html` は対応する md と内容がずれている
（md 更新後に再生成されていない）。手元での再現結果が合わなくても、それが原因のことがある。

## その他

- URL 短縮 (Firebase Dynamic Links) はサービス終了に伴い `entrypoint.sh` で無効化済み
- ワークフローは push 時に走るが、`.md` の変更が1つも無いと CHANGED_FILES 作成の行で失敗する
