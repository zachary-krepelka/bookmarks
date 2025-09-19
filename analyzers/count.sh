#!/usr/bin/env bash

# FILENAME: count.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, January 3rd, 2024
# ABOUT: a script to count entries in a Netscape bookmark file
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, September 18th, 2025 at 4:48 PM

# Functions --------------------------------------------------------------- {{{1

program="${0##*/}"

usage() {
	cat <<-USAGE
	Count your bookmark entries

	Usage:
	  bash $program [options] <netscape-bookmark-file> ...

	Options:
	  -h  display this [h]elp message and exit
	  -H  read documentation for this script then exit
	  -a  [a]ggregate input files
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

	local dependencies=(cat column grep less pod2text)

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

aggregate=1

while getopts ahH option
do
	case "$option" in

		a) aggregate=0;;
		h) usage;;
		H) documentation;;

	esac
done

shift "$((OPTIND - 1))"

# Error Handling ---------------------------------------------------------- {{{1

# Check that positional arguments were supplied.

if test $# -eq 0
then error 2 'At least one argument is required. Try -h for help.'
fi

# Check that each argument is a bookmark file.

for file
do
	if grep -Fqsm1 '<!DOCTYPE NETSCAPE-Bookmark-file-1>' "$file"
	then continue
	fi

	error 3 "$file does not appear to be a bookmark file."
done

# Processing -------------------------------------------------------------- {{{1

# If there is only one file or if all the files are aggregated together,
# then we do not need to include filenames in the output.

if test $# -eq 1 || test $aggregate -eq 0
then
	bookmarks="$(grep -c '<A'  $@)"
	folders="$(grep -c '<H3' $@)"
	total="$((bookmarks + folders))"

	cat <<-EOF
	Bookmarks: $bookmarks
	Folders:   $folders
	Total:     $total
	EOF

	exit 0
fi

# Otherwise, let's output a table that distinguishes between files.

for file
do
	bookmarks="$(grep -c '<A'  $file)"
	folders="$(grep -c '<H3' $file)"
	total="$((bookmarks + folders))"

	echo "$file $bookmarks $folders $total"

done | column -t -N FILE,BOOKMARKS,FOLDERS,TOTAL

# Documentation ----------------------------------------------------------- {{{1

# https://charlotte-ngs.github.io/2015/01/BashScriptPOD.html
# http://bahut.alma.ch/2007/08/embedding-documentation-in-shell-script_16.html

: <<='cut'
=pod

=head1 NAME

count.sh - count your bookmark entries

=head1 SYNOPSIS

bash count.sh [options] <netscape-bookmark-file> ...

=head1 DESCRIPTION

The purpose of this script is to count the number of bookmark entries in a
Netscape bookmark file.  The input is one or more files in the Netscape Bookmark
file format.  The output is a table displaying the number of bookmarks and
folders in each file.

When only one file is supplied, the output looks like this.

	Bookmarks: 17455
	Folders:   870
	Total:     18325

But when multiple files are supplied, we get something different.

	FILE         BOOKMARKS  FOLDERS  TOTAL
	first.html   17455      870      18325
	second.html  3167       90       3257
	third.html   1602       4        1606

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

=item B<-a>

This will give a cumulative total of the entries in all the files together
instead of processing each file individually.  The output will be as if only one
file was passed.  Note that [a] stands for [a]ggregate.

=back

=head1 DIAGNOSTICS

The program exits with the following status codes.

=over

=item 0 if okay

=item 1 if dependencies are missing

=item 2 if no positional arguments were supplied

=item 3 if a positional argument is invalid

=over

=item arguments must be regular files

=item arguments must be files in the Netscape bookmark file format

=back

=back

=head1 NOTES

Greppability was not a design consideration.  I prefer verbose, annotated
output.  This is contrary to Unix philosophy which prefers minimal output.  For
example, the word count utility only outputs numbers.

	person@computer:~$ wc README.md
	 201 1164 8187 README.md
	person@computer:~$

A future consideration is to implement a C<--verbose> flag.  This script could
be made to behave more like C<wc> when the flag is not supplied.

Again on the note of greppability, having a variable output format may be an
antipattern.  However, this is what I prefer for my purposes.

Another observation to bear in mind is that the root directory is included in
the folder count, which may not be desired.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

# vim: tw=80 ts=8 sw=8 noet fdm=marker
