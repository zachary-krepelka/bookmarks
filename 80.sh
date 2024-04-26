#!/usr/bin/env bash

# FILENAME: 80.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024
# ABOUT: identify bookmark entries exceeding 80 characters
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, April 25th, 2024 at 9:39 PM

# PURPOSE

	# The purpose of this script is to
	# identify bookmark entries that
	# exceed 80 characters in length.

		# https://www.emacswiki.org/emacs/EightyColumnRule

usage() { program=$(basename $0); cat <<-EOF >&2
Usage: $program [options] <file>
identify bookmark entries exceeding 80 characters

Options:
	-h          display this [h]elp message
	-n {num}    use your own [n]umber

Example:       bash $program bookmarks.html
Documentation: perldoc $program
EOF
exit 0
}

num=80

while getopts hn: option
do
	case $option in

		h) usage;;
		n) num=$OPTARG;;

	esac
done
shift $((OPTIND-1))

[ "$1" == "--help" ] && usage

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
grep ".\{$num,\}" | sort -u

: <<='cut'
=pod

=head1 NAME

80.sh - identify bookmark entries exceeding 80 characters

=head1 SYNOPSIS

bash 80.sh <bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to identify bookmark entries with lengthy names.
A concise name is easy to read, and a long name is not.  The input is a file in
the Netscape Bookmark file format.  The output is a list of bookmark entries.

In spirit of a common programming convention, our script reports bookmark
entries with names exceeding 80 characters, but you can choose your own number
with the B<-h> flag.

	https://www.emacswiki.org/emacs/EightyColumnRule

=head1 OPTIONS

=over

=item B<-h>

Display a [h]elp message and exit.

=item B<-n> I<NUM>

Identify bookmark entries exceeding I<NUM> characters.

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
