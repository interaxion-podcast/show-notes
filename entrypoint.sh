#!/bin/sh -l

for md in $(ls md/*.md); do
    num=$(echo $md | sed 's/.*ep\(.*\).md/\1/g')
    pandoc -f markdown-auto_identifiers -t html md/ep$num.md -o html/ep$num.html
done

