# add-chapters

MP3 にチャプターとメタデータ (タイトル・アートワーク) を付ける。

## 準備

```sh
pip3 install -r requirements.txt
```

## 使い方

```sh
chapters/add-chapters.sh          # finished_audio 内の最新 MP3 1件だけ
chapters/add-chapters.sh --all    # ファイル名に old を含むものを除く全件
```

音声の置き場所は `AUDIO_DIR` で変えられる。既定はリポジトリと同じ階層の `finished_audio`
(`show-notes` と `finished_audio` が並んでいる従来の配置を想定)。

```sh
AUDIO_DIR=/path/to/mp3 chapters/add-chapters.sh
```

個別に実行したい場合は、`chapters/` に移動してから `add-chapters.py` を直接呼ぶ
(`episodes.yml` と `cover_art.jpg` を相対パスで開くため、CWD が `chapters/` である必要がある)。

```sh
cd chapters && python3 add-chapters.py /path/to/68.mp3
```

## 注意

- MP3 のファイル名は `68.mp3` / `19.5.mp3` のように**エピソード番号のみ**である必要がある。
  この番号で `episodes.yml` を引く。
- `episodes.yml` は `../md/ep*.md` を元に GitHub Actions が生成する。
  新しい回のチャプターを付ける前に、**最新の master を pull しておくこと**。
- タイムスタンプの無い見出し (「お知らせ」など) はチャプターにならない。
- 実行すると `add-chapters.py` が該当回に当たるまで全エピソードを標準出力に吐くが、
  デバッグ出力なので無視してよい。

## 出典

- Forked from [rui314/add-chapters.py](https://gist.github.com/rui314/6e435fcebe3998333d37904e893c8c12).
