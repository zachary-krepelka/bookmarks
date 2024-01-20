#!/usr/bin/env bash

# FILENAME: duplicates.sh
# AUTHOR: Zachary Krepelka
# DATE: Monday, December 25th, 2023

# PURPOSE

	# The purpose of this script is to identify duplicate bookmarks in a
	# Netscape bookmark file.  A bookmark entry entails its name and
	# associated URL.  The program can identify duplicates in each.

usage() {
cat << EOF >&2
Usage: $0 [OPTION]... [FILE]...
Identify duplicate entries in a bookmark file.

Options:
	-h	display this help message
	-i	enable case insensitivity
	-d	distinquish between files
	-s	switch from name to url
	-c	cut trailing slash

Example:
	$0 bookmarks.html
EOF
exit 0
}

# VARIABLES

	TYPE=NAME
	REGEX='(?<=>)[^<]*(?=</A>)'

	CASE_INSENSITIVE=1
	REMOVE_TAIL=1
	DISTINCT=1
	ARGS=()

# COMMAND LINE ARGUMENT PARSING

	# Our program takes options and positional arguments. This was helpful:

	# https://gist.github.com/caruccio/836c2dda2bdfa5666c5f9b0230978f26

	while [ $# -gt 0 ]; do

		while getopts hicds options; do

			case $options in

				h) usage;;

				i) CASE_INSENSITIVE=0;;

				c) REMOVE_TAIL=0;;

				d) DISTINCT=0;;

				s)
					TYPE=URL
					REGEX='(?<=HREF=")[^"]+'
				;;
			esac
		done

		[ $? -eq 0 ] || exit 1
		[ $OPTIND -gt $# ] && break

		shift $[$OPTIND - 1]
		OPTIND=1
		ARGS[${#ARGS[*]}]=$1
		shift
	done

	if [ ${#ARGS[*]} -lt 1 ]; then
		echo 'At least one argument is required. Try -h for help.' 1>&2
		exit 1
	fi

# CORE PROGRAM FUNCTIONALITY

	grep \
		--perl-regexp \
		--only-matching \
		--$(
			if [ $DISTINCT -eq 0 ]
			then
				echo with
			else
				echo no
			fi
		)-filename \
		$REGEX ${ARGS[*]} |
	\
	if [ $CASE_INSENSITIVE -eq 0 ]
	then
		tr '[:upper:]' '[:lower:]'
	else
		cat
	fi |
	\
	if [ $REMOVE_TAIL -eq 0 ] && [ "$TYPE" = "URL" ]
	then
		sed 's/\/$//'
	else
		cat
	fi |
	\
	sort | uniq -cd | sed 's/^\s*//' |
	\
	if [ $DISTINCT -eq 0 ]
	then
		sed 's/:/ /' | column -t -l 3 -N FREQ,FILE,$TYPE
		# Assumes that input filenames do not contain spaces.
	else
		column -t -l 2 -N FREQ,$TYPE
	fi
