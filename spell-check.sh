#!/usr/bin/env sh

# FILENAME: spell-check.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024

# PURPOSE

	# The purpose of this script is
	# to identify spelling mistakes
	# within bookmark entries.

# REMARK

	# It may help to pipe the result into less with the -R flag, like this:

		# bash spell-check.sh bookmarks.html | less -R

if [[ $# -ne 1 ]]; then
	echo 'Exactly one argument is required.' 1>&2
	exit 1
fi

while read line; do

	echo $line | grep -F --color=ALWAYS -f <(echo $line | aspell list)

done < <(sed -f - <(grep -Po '(?<=>)[^<]*(?=</A>)' $1) <<-EOF |

	s/&amp;/\&/g
	s/&lt;/</g
	s/&gt;/>/g
	s/&#39;/'/g
	s/&quot;/"/g

EOF
sort -u)
