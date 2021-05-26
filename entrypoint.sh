#!/bin/sh -l

# URL 短縮
for md in $(ls md/*.md); do
    python3 scripts/shorten_urls_md.py $md i8n $FDL_KEY > tmp.md
    mv tmp.md $md.tmp
done

# Markdown to HTML
for md in $(ls md/*.md); do
    num=$(echo $md | sed 's/.*ep\(.*\).md/\1/g')
    pandoc -f markdown-auto_identifiers -t html md/ep$num.md.tmp -o tmp.html
    # 改行
    tr -d '\n'  < tmp.html > html/ep$num.html
done

## Create YAML for adding chapters in MP3.

yml="chapters/episodes.yml"

echo "---" > $yml

for md in $(ls -1 md/*.md)
do
    epnum=$(echo $md | head -1 | sed --regex 's/.*ep(\d+|\d+\.\d)\.md/\1/')
    echo "episode: $epnum" >> $yml
    title=$(cat $md | head -1 |sed -n --regex 's/.*[Ee]p\.[\s ](\d+|\d+\.\d)[\s ](.*)/\2/p')
    echo "title: $title" >> $yml
    echo "topics:" >> $yml
    cat $md | sed -n --regex 's/(#+)\s([0-9:]+)\s(.+)/\3(\2\)/gp' | awk '{printf "    - %s\n", $0}'>> $yml
    echo "---" >> $yml
done
