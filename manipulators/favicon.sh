#!/usr/bin/env bash

# FILENAME: favicon.sh
# AUTHOR: Zachary Krepelka
# DATE: Saturday, October 28, 2023
# ABOUT: repopulate missing bookmark favicons
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, September 18th, 2025 at 7:32 PM

# Functions --------------------------------------------------------------- {{{1

program="${0##*/}"

usage() {
	cat <<-USAGE
	Repopulate missing bookmark favicons

	Usage:
	  bash $program [options] <input-file> <output-file>

	Options:
	  -h  display this [h]elp message and exit
	  -H  read documentation for this script then exit
	USAGE
	exit 0
}

documentation() {
	pod2text "$0" | less -Sp '^[^ ].*$' +k
	exit 0
}

error() {
	local code="$1"
	local message="$2"
	echo "$program: error: $message" >&2
	exit "$code"
}

check_dependencies() {

	local dependencies=(
		base64 cat cp grep less mkdir
		pod2text rm sed sort wc wget
	)

	local missing=

	for cmd in "${dependencies[@]}"
	do
		if ! command -v "$cmd" &>/dev/null
		then missing+="$cmd, "
		fi
	done

	if test -n "$missing"
	then error 1 "missing dependencies: ${missing%, }"
	fi
}

# Command-line Argument Parsing ------------------------------------------- {{{1

check_dependencies # must be called before any external command

while getopts hH option
do
	case "$option" in
		h) usage;;
		H) documentation;;
	esac
done

shift "$((OPTIND - 1))"

if test $# -ne 2
then error 2 'Exactly two arguments are required. Try -h for help.'
fi

# Processing -------------------------------------------------------------- {{{1

clear
echo Please Wait

workspace=/tmp/favicons

input_file="$1"
output_file="$2"

mkdir -p "$workspace"
cp "$input_file" "$output_file"

# We create a list of all root domains in the bookmark file.

list="$workspace/list.txt"

grep -oP '(?<=:\/\/)[^\/]+' "$output_file" | sort -u > "$list"

# We loop over each website in the list.

count=0
total="$(wc -l < "$list")"

while read website; do

	clear
	((++count))
	echo "$count of $total"

	# We get the website's icon using Google's favicon API.

	icon_file="$workspace/$website"

	wget -q -O "$icon_file" --tries 1 --timeout 3 \
	"http://www.google.com/s2/favicons?domain_url=$website"

	# We skip if the icon file is empty.

	if [ ! -s "$icon_file" ]; then
		continue
	fi

	# We turn the website into a valid regular expression.

	escaped_website="$(echo $website | sed 's/\./\\\./g')"

		# (Am I missing any metachracters?)

	# We remove any existing icon data from the matching entries.

	sed -i "/$escaped_website/ s/ ICON=\"[^\"]\+\"//" "$output_file"

		# (Double quotes are required for string interpolation.)

	# We encode the icon into base64.

	encoding="$(
		base64 -w 0 "$icon_file" |
		sed 's/\(.*\)/ICON="data:image\/png;base64,\1"/'
	)"

	# We inject the encoded icon into the bookmark file.

	sed -i -f - "$output_file" <<-EOF
	/$escaped_website/ s|">|" $encoding>|g
	EOF

	# The heredoc is a necessity.  See here:

	# 	https://unix.stackexchange.com/q/284170

done < "$list"

# We clean up the mess.

rm -rf "$workspace"

# Documentation ----------------------------------------------------------- {{{1

# https://charlotte-ngs.github.io/2015/01/BashScriptPOD.html
# http://bahut.alma.ch/2007/08/embedding-documentation-in-shell-script_16.html

: <<='cut'
=pod

=head1 NAME

favicon.sh - repopulate missing bookmark favicons

=head1 SYNOPSIS

Below I describe the program's input, output, and usage.

=head2 Usage

bash favicon.sh [options] <input-file> <output-file>

=head2 Input

The input is a file in the Netscape Bookmark file format.  This file format was
originally created to store bookmarks for the Netscape web browser.  All major
web browsers today use this standard to import and export bookmarks.  These
files have the html extension with the HTML document type declaration <!DOCTYPE
NETSCAPE-Bookmark-file-1>.  They are usually called bookmarks.html by default.

=head2 Output

The output is a file in the same format.

=head1 DESCRIPTION

The purpose of this script is to repopulate one's bookmark favicons.  A favicon
is a small icon associated with a website.  When one bookmarks a website in a
web browser, the favicon helps to visually identify that bookmark entry.

Sometimes these favicons disappear.  Then an unhelpful globe icon takes its
place.  This script is meant to address this issue.  Simply export your
bookmarks from your web browser and run this script on that file.  A new file
will result that you can import back into your web browser, favicons and all.

=head1 OPTIONS

=over

=item B<-h>

Display a [h]elp message and exit.

=item B<-H>

Display this documentation in a pager and exit after the user quits.  The
documentation is divided into sections.  Each section header is matched with a
search pattern, meaning that you can use navigation commands like C<n> and its
counterpart C<N> to go to the next or previous section respectively.

The uppercase -H is to parallel the lowercase -h.

=back

=head1 DIAGNOSTICS

The program exits with the following status codes.

=over

=item 0 if okay

=item 1 if dependencies are missing

=item 2 if the wrong number of positional arguments are supplied

=back

=head1 CAVEATS

Only tested with Google Chrome.
The program may take a long time to run.

=head1 TODO

Reimplement this in a better language. A complete rewrite is overdue.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

# vim: tw=80 ts=8 sw=8 noet fdm=marker
