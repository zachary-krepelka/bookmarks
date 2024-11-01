#!/usr/bin/env bash

# FILENAME: count.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, January 3rd, 2024
# ABOUT: a script to count entries in a Netscape bookmark file
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Friday, April 26th, 2024 at 12:05 AM

usage() { program=$(basename $0); cat <<-EOF >&2
Usage: $program [options] <file>
count your bookmark entries

Options:
	-h	display this [h]elp message
	-r	count the [r]oot directory

Example:       bash $program bookmarks.html
Documentation: perldoc $program
EOF
exit 0
}

root=false

while getopts hr option
do
	case $option in

		h) usage;;
		r) root=true;;
	esac
done
shift $((OPTIND-1))

[ "$1" == "--help" ] && usage

if [[ $# -ne 1 ]]; then
	echo 'Exactly one argument is required. Try -h for help.' 1>&2
	exit 1
fi

bookmarks=$(grep '<A' $1 | wc -l)
folders=$(grep '<H3' $1 | wc -l)

if ! $root
then
	((--folders))
fi

total=$(expr $bookmarks + $folders)

cat << EOF
Bookmarks: $bookmarks
Folders:   $folders
Total:     $total
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

=head1 OPTIONS

=over

=item B<-h>

Display a [h]elp message and exit.

=item B<-r>

Include the [r]oot directory while counting the number of folders.

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
