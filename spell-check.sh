#!/usr/bin/env bash

# FILENAME: spellcheck.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024
# UPDATED: Thursday, March 28th, 2024 at 8:40 PM

# PURPOSE

	# The purpose of this script is
	# to identify spelling mistakes
	# within bookmark entries.

usage() {
	PROG=$(basename $0)
	cat <<-EOF >&2
		Usage: $PROG [option] <file>
		spellcheck your bookmark entries

		Documentation:  perldoc $PROG
		Options:        -h to display this help message
		Example:        bash $PROG bookmarks.html
	EOF
	exit 0
}

[ "$1" == "-h" -o "$1" == "--help" ] && usage

if [[ $# -ne 1 ]]
then
	echo 'Exactly one argument is required. Try -h for help.' 1>&2
	exit 1
fi

set -f # disable globbing

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

: <<='cut'
=pod

=head1 NAME

spellcheck.sh - spellcheck your bookmark entries

=head1 SYNOPSIS

bash spellcheck.sh <bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to identify spelling mistakes within bookmark
entries.  The input is a file in the Netscape Bookmark file format.  The output
is a list of bookmark entries with spelling mistakes highlighted.

=head1 NOTES

It may help to pipe the result into less with the -R flag, like this:

	bash spellcheck.sh bookmarks.html | less -R

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
