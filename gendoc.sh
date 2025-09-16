#!/usr/bin/env bash

# FILENAME: gendoc.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, April 9th, 2025
# ABOUT: generate documentation in various formats
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Monday, September 15th, 2025 at 10:03 PM

declare -A formats

formats[html]=html
formats[man]=1
formats[pdf]=pdf
formats[text]=txt

rm -rf docs
for fmt in "${!formats[@]}"
do mkdir -p docs/$fmt
done

shopt -s globstar

for file in */**
do
	if test ! -f "$file"
	then continue
	fi

	ext="${file##*.}"

	for fmt in "${!formats[@]}"
	do
		dest="docs/$fmt/${file////.}.${formats[$fmt]}"

		case "$ext" in

			ahk|pl|sh) pod2$fmt $file > $dest;;
			sed|jq)
				sed -nf - $file <<-EXTRACT | pod2$fmt > $dest
				/^# =pod/,/^# =cut/{
					s/^# \?//
					p
				}
				EXTRACT
			;;
			*) continue;;
		esac
	done
done

rm -f pod2htmd.tmp # Why isn't this cleaned up automatically?
