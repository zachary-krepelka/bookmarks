#!/usr/bin/env bash

# FILENAME: count.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, January 3rd, 2024
# UPDATED: Thursday, March 28th, 2024 at 8:40 PM

# PURPOSE

	# The purpose of this script is to count
	# the number of bookmark entries in a
	# Netscape bookmark file.

usage() {
	PROG=$(basename $0)
	cat <<-EOF >&2
		Usage: $PROG [option] <file>
		count your bookmark entries

		Documentation:  perldoc $PROG
		Options:        -h to display this help message
		Example:        bash $PROG bookmarks.html
	EOF
	exit 0
}

[ "$1" == "-h" -o "$1" == "--help" ] && usage

if [[ $# -ne 1 ]]; then
	echo 'Exactly one argument is required. Try -h for help.' 1>&2
	exit 1
fi

cat << EOF
Bookmarks: $(grep '<A'  $1 | wc -l)
Folders:   $(grep '<H3' $1 | wc -l)
Total:     $(grep '<DT' $1 | wc -l)
EOF

: <<='cut'
=pod

=head1 NAME

count.sh - count your bookmark entries

=head1 SYNOPSIS

bash count.sh <bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to count the number of bookmark entries in a
Netscape bookmark file.  The input is a file in the Netscape Bookmark file
format.  The output is a table displaying the number of bookmarks and folders in
that file.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
