#!/usr/bin/env bash

# FILENAME: 80.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024
# UPDATED: Thursday, March 28th, 2024 at 8:40 PM

# PURPOSE

	# The purpose of this script is to
	# identify bookmark entries that
	# exceed 80 characters in length.

		# https://www.emacswiki.org/emacs/EightyColumnRule

usage() {
	PROG=$(basename $0)
	cat <<-EOF >&2
		Usage: $PROG [option] <file>
		identify bookmark entries exceeding 80 chars

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

sed -f - <(grep -Po '(?<=>)[^<]*(?=</A>)' $1) <<-EOF |

	s/&amp;/\&/g
	s/&lt;/</g
	s/&gt;/>/g
	s/&#39;/'/g
	s/&quot;/"/g

EOF
grep '.\{80,\}' | sort -u

: <<='cut'
=pod

=head1 NAME

80.sh - identify bookmark entries exceeding 80 characters

=head1 SYNOPSIS

bash 80.sh <bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to identify bookmark entries that exceed 80
characters in length.  The input is a file in the Netscape Bookmark file format.
The output is a list.  Why write a script like this?  A consise name is easy to
read.  A long name is not.

	https://www.emacswiki.org/emacs/EightyColumnRule

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
