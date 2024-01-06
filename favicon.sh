#!/usr/bin/env bash

# FILENAME: favicon.sh
# AUTHOR: Zachary Krepelka
# DATE: Saturday, October 28, 2023

# USAGE

	# bash favicon.sh <input.html> <output.html>

		# where 'input.html' is in the Netscape bookmark file format.

# PURPOSE

	# The purpose of this script is to repopulate one's bookmark favicons.
	# A favicon is a small icon associated with a website.  When one
	# bookmarks a website in a web browser, the favicon helps to visually
	# identify that bookmark entry.

	# Sometimes these favicons disappear.  Then an unhelpful globe icon
	# takes its place.  This script is meant to address this issue.  Simply
	# export your bookmarks from your web browser and run this script on
	# that file.  A new file will result that you can import back into your
	# web browser, favicons and all.

# DISCLAIMER

	# Only tested with Google Chrome.

if [[ $# -ne 2 ]]; then
	echo 'Exactly two arguments are required.' 1>&2
	exit 1
fi

clear
echo Please Wait

workspace=/tmp/favicons

input_file=$1
output_file=$2

mkdir -p $workspace
cp $input_file $output_file

# We create a list of all root domains in the bookmark file.

list=$workspace/list.txt

grep -oP '(?<=:\/\/)[^\/]+' $output_file | sort -u > $list

# We loop over each website in the list.

count=0
total=$(wc -l < $list)

while read website; do

	clear
	((++count))
	echo $count of $total

	# We get the website's icon using Google's favicon API.

	icon_file=$workspace/$website

	wget -q -O $icon_file --tries 1 --timeout 3 \
	http://www.google.com/s2/favicons?domain_url=$website

	# We skip if the icon file is empty.

	if [ ! -s $icon_file ]; then
		continue
	fi

	# We turn the website into a valid regular expression.

	escaped_website=$(echo $website | sed 's/\./\\\./g')

		# (Am I missing any metachracters?)

	# We remove any existing icon data from the matching entries.

	sed -i "/$escaped_website/ s/ ICON=\"[^\"]\+\"//" $output_file

		# (Double quotes are required for string interpolation.)

	# We encode the icon into base64.

	encoding=$(
		base64 -w 0 $icon_file |
		sed 's/\(.*\)/ICON="data:image\/png;base64,\1"/'
	)

	# We inject the encoded icon into the bookmark file.

	sed -i -f - $output_file <<-EOF
	/$escaped_website/ s|">|" $encoding>|g
	EOF

	# The heredoc is a necessity.  See here:

	# 	https://unix.stackexchange.com/q/284170

done < $list

# We clean up the mess.

rm -rf $workspace

# UPDATED: Thursday, January 4th, 2024   6:33 PM
