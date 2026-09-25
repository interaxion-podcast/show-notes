#!/bin/bash
#
# finished_audio 内の MP3 にチャプターとメタデータを付ける。
#
#   chapters/add-chapters.sh          # 最新の1件だけ (既定)
#   chapters/add-chapters.sh --all    # ファイル名に old を含むものを除く全件
#
# 音声の置き場所は AUDIO_DIR で変えられる。既定はリポジトリと同じ階層の
# finished_audio (従来どおり show-notes と finished_audio が並んでいる前提)。
#
#   AUDIO_DIR=/path/to/mp3 chapters/add-chapters.sh
#
# episodes.yml は md/ep*.md から GitHub Actions が生成するので、
# 先に最新の master を pull しておくこと。

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
AUDIO_DIR=${AUDIO_DIR:-$(dirname "$REPO_ROOT")/finished_audio}

if [ ! -d "$AUDIO_DIR" ]; then
    echo "音声ディレクトリが見つかりません: $AUDIO_DIR" >&2
    echo "AUDIO_DIR=/path/to/mp3 で指定してください。" >&2
    exit 1
fi

# add-chapters.py は episodes.yml と cover_art.jpg を相対パスで開くので
# chapters/ に移動してから実行する。
cd "$SCRIPT_DIR"

mp3s=()
while IFS= read -r line; do
    mp3s+=("$line")
done < <(ls -1t "$AUDIO_DIR"/*.mp3 2>/dev/null || true)

if [ "${#mp3s[@]}" -eq 0 ]; then
    echo "MP3 が見つかりません: $AUDIO_DIR" >&2
    exit 1
fi

targets=()
if [ "${1:-}" = "--all" ]; then
    for mp3 in "${mp3s[@]}"; do
        case "$(basename "$mp3")" in
            *old*) echo "skip: $mp3" ;;
            *)     targets+=("$mp3") ;;
        esac
    done
elif [ $# -gt 0 ]; then
    echo "不明な引数: $1" >&2
    echo "使い方: $0 [--all]" >&2
    exit 1
else
    targets=("${mp3s[0]}")
fi

for mp3 in "${targets[@]}"; do
    echo "add-chapters for $mp3"
    python3 add-chapters.py "$mp3"
done
