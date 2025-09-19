#!/usr/bin/env bash

# FILENAME: 80.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024
# ABOUT: identify bookmark entries exceeding 80 characters
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, September 18th, 2025 at 7:25 PM

# PURPOSE

	# The purpose of this script is to
	# identify bookmark entries that
	# exceed 80 characters in length.

		# https://www.emacswiki.org/emacs/EightyColumnRule

# Functions --------------------------------------------------------------- {{{1

program="${0##*/}"

usage() {
	cat <<-USAGE
	Identify bookmark entries exceeding 80 characters

	Usage:
	  bash $program [options] <netscape-bookmark-file>

	Options:
	  -h      display this [h]elp message and exit
	  -H      read documentation for this script then exit
	  -n NUM  use your own [n]umber
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

	local dependencies=(cat grep less pod2text sed sort)

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

num=80

while getopts hHn: option
do
	case "$option" in

		h) usage;;
		H) documentation;;
		n) num="$OPTARG";; # TODO check that it's a number
	esac
done

shift "$((OPTIND - 1))"

if test $# -ne 1
then error 2 'Exactly one argument is required. Try -h for help.'
fi

# Processing -------------------------------------------------------------- {{{1

sed -f - <(grep -Po '(?<=>)[^<]*(?=</A>)' $1) <<-'EOF' |

	# TODO outsource HTML decoding to an external program
	# TRY perl -MHTML::Entities -pe 'decode_entities($_);'

	s/&amp;/\&/g
	s/&lt;/</g
	s/&gt;/>/g
	s/&#39;/'/g
	s/&quot;/"/g

EOF
grep ".\{$num,\}" | sort -u

# Documentation ----------------------------------------------------------- {{{1

# https://charlotte-ngs.github.io/2015/01/BashScriptPOD.html
# http://bahut.alma.ch/2007/08/embedding-documentation-in-shell-script_16.html

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

=item B<-H>

Display this documentation in a pager and exit after the user quits.  The
documentation is divided into sections.  Each section header is matched with a
search pattern, meaning that you can use navigation commands like C<n> and its
counterpart C<N> to go to the next or previous section respectively.

The uppercase -H is to parallel the lowercase -h.

=item B<-n> I<NUM>

Identify bookmark entries exceeding I<NUM> characters.

=back

=head1 DIAGNOSTICS

The program exits with the following status codes.

=over

=item 0 if okay

=item 1 if dependencies are missing

=item 2 if the wrong number of positional arguments are supplied

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

# vim: tw=80 ts=8 sw=8 noet fdm=marker
