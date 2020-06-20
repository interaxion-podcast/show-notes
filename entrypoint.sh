#!/bin/sh -l

# URL 短縮
for md in $(ls md/*.md); do
    echo $md
    python3 shorten_urls_md.py $md i8n $FDL_KEY
    mv tmp.md $md
done

# Markdown to HTML
for md in $(ls md/*.md); do
    num=$(echo $md | sed 's/.*ep\(.*\).md/\1/g')
    pandoc -f markdown-auto_identifiers -t html md/ep$num.md -o tmp.html
    # 改行と <li> の閉じタグを除去
    tr -d '\n'  < tmp.html | sed 's/<\/li>//g' > html/ep$num.html
done

## Create YAML for adding chapters in MP3.

yml="chapters/episodes.yml"

echo "---" > $yml

for md in $(ls -1 md/*.md)
do
    epnum=$(echo $md | sed --regex 's/.*ep([0-9]+)\.md/\1/')
    echo "episode: $epnum" >> $yml
    title=$(cat $md | sed -n --regex 's/.*[Ee]p\.[\s ][0-9+][\s ](.*)/\1/p')
    echo "title: $title" >> $yml
    echo "topics:" >> $yml
    cat $md | sed -n --regex 's/(#+)\s([0-9:]+)\s(.+)/\3(\2\)/gp' | awk '{printf "    - %s\n", $0}'>> $yml
    echo "---" >> $yml
done
