#!/bin/sh -l

for md in $(ls md/*.md); do
    num=$(echo $md | sed 's/.*ep\(.*\).md/\1/g')
    pandoc -f markdown-auto_identifiers -t html md/ep$num.md -o html/ep$num.html
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
    cat $md | sed -n --regex 's/(#+)\s([0-9:]+)\s(.+)/\3(\2\)/gp' >> $yml
    echo "---" >> $yml
done
