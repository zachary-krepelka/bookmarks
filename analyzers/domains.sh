#!/usr/bin/env bash

# FILENAME: domains.sh
# AUTHOR: Zachary Krepelka
# DATE: Saturday, March 30th, 2024
# ABOUT: analyze domain frequencies in a bookmark file
# ORIGIN: https://github.com/zachary-krepelka/bookmarks
# UPDATED: Saturday, September 20th, 2025 at 7:17 AM

# Functions --------------------------------------------------------------- {{{1

program="${0##*/}"

usage() {
	cat <<-USAGE
	Analyze domain frequencies in a bookmark file

	Usage:
	  bash $program [options] <netscape-bookmark-file>

	Options:
	  -h      display this [h]elp message
	  -H      read documentation for this script then exit
	  -m NUM  specifies [m]inimum frequency to appear in report
	  -M NUM  specifies [M]aximum frequency to appear in report
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

	local dependencies=(cat column grep less pod2text sort)

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

min=0
max=0

while getopts hHm:M: option
do
	case "$option" in
		h) usage;;
		H) documentation;;
		m) min="$OPTARG";; # TODO check that it's a number
		M) max="$OPTARG";; # TODO ditto
	esac
done

shift "$((OPTIND - 1))"

if test $# -eq 0
then error 2 'At least one argument is required. Try -h for help.'
fi

# Processing -------------------------------------------------------------- {{{1

hrefs="$(grep -oP '(?<=HREF=")[^"]+' "$@")"

for domain in $(grep -oP '(?<=:\/\/)[^\/]+' <(echo "$hrefs") | sort -u)
do
	num="$(grep -cF "://$domain" <(echo "$hrefs"))"

	if test "$num" -lt "$min"
	then continue
	fi

	if test "$max" -ne 0
	then
		if test "$num" -gt "$max"
		then continue
		fi
	fi

	echo "$num $domain"

done | column -t -N FREQ,DOMAIN

# Documentation ----------------------------------------------------------- {{{1

# https://charlotte-ngs.github.io/2015/01/BashScriptPOD.html
# http://bahut.alma.ch/2007/08/embedding-documentation-in-shell-script_16.html

: <<='cut'
=pod

=head1 NAME

domains.sh - analyze domain frequencies in a bookmark file

=head1 SYNOPSIS

bash domains.sh [options] <netscape-bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to analyze domain frequencies in a bookmark file.
The input is a file in the Netscape bookmark file format. The output is a
formatted table to STDOUT. The table reports each unique domain in the file
together with the frequency of bookmark entries belonging to that domain.

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

=item B<-m> I<NUM>

Specifies the minimum frequency to appear in the output.
This allows the user to filter out one-off domains.

	bash domains.sh -m 10 bookmarks.html > double-digits-and-up.txt

	bash domains.sh -m 100 bookmarks.html > triple-digits-and-up.txt

=item B<-M> I<NUM>

Specifies the maximum frequency to appear in the output.  Compounded with -m,
use it to find domain frequencies in a range.

	bash domains.sh -m 10 -M 20 bookmarks.html > a-lot-but-not-a-lot.txt

=back

=head1 DIAGNOSTICS

The program exits with the following status codes.

=over

=item 0 if okay

=item 1 if dependencies are missing

=item 2 if no positional arguments were supplied

=back

=head1 EXAMPLE

Consider the following command.

	bash domains.sh -m 1000 bookmarks.html

This will identify all domains in your bookmark file for which there are at
least 1,000 bookmarks under that domain. Here's what the output looks like ran
against my own bookmark file.

	FREQ  DOMAIN
	1205  en.wikipedia.org
	1043  stackoverflow.com
	1036  www.merriam-webster.com
	2177  www.youtube.com

This means, for example, that I've bookmarked 1,036 entries in Merriam-Webster's
online dictionary.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

# vim: tw=80 ts=8 sw=8 noet fdm=marker
