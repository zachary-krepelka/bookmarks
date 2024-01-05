#!/usr/bin/env bash

# FILENAME: count.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, January 3rd, 2024

# PURPOSE

	# The purpose of this script is to count
	# the number of bookmark entries in a
	# Netscape bookmark file.

if [[ $# -ne 1 ]]; then
	echo 'Exactly one argument is required.' 1>&2
	exit 1
fi

cat << EOF
Bookmarks: $(grep '<A'  $1 | wc -l)
Folders:   $(grep '<H3' $1 | wc -l)
Total:     $(grep '<DT' $1 | wc -l)
EOF
