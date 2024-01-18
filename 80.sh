#!/usr/bin/env bash

# FILENAME: 80.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024

# PURPOSE

	# The purpose of this script is to
	# identify bookmark entries that
	# exceed 80 characters in length.

		# https://www.emacswiki.org/emacs/EightyColumnRule

if [[ $# -ne 1 ]]; then
	echo 'Exactly one argument is required.' 1>&2
	exit 1
fi

sed -f - <(grep -Po '(?<=>)[^<]*(?=</A>)' $1) <<-EOF |

	s/&amp;/\&/g
	s/&lt;/</g
	s/&gt;/>/g
	s/&#39;/'/g
	s/&quot;/"/g

EOF
grep '.\{80,\}' | sort -u
