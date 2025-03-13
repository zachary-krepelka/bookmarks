#!/usr/bin/env bash

# FILENAME: count.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, January 3rd, 2024
# ABOUT: a script to count entries in a Netscape bookmark file
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, March 13th, 2025 at 2:20 AM

program=$(basename $0)

usage() {
	cat <<-USAGE
	Usage: $program [options] <files>
	count your bookmark entries

	Options:
	  -a	[a]ggregate input files
	  -h	display this [h]elp message

	Example:       bash $program bookmarks.html
	Documentation: perldoc $program
	USAGE
	exit 0
}

error() {

	echo "$program: $2" 1>&2
	exit $1
}

# Process command-line options.

aggregate=1

while getopts ah option
do
	case $option in

		a) aggregate=0;;
		h) usage;;

	esac
done

shift $((OPTIND-1))

# Check that positional arguments were supplied.

if test $# -eq 0
then error 1 'At least one argument is required. Try -h for help.'
fi

# Check that each argument is a regular file,
# and if so, that it is a bookmark file.

for file
do
	if grep -Fqsm1 '<!DOCTYPE NETSCAPE-Bookmark-file-1>' "$file"
	then continue
	fi

	error 2 "$file does not appear to be a bookmark file."
done

# If there is only one file or if all the files are aggregated together,
# then we do not need to include filenames in the output.

if test $# -eq 1 || test $aggregate -eq 0
then
	bookmarks=$( grep '<A'  $@ | wc -l)
	folders=$(   grep '<H3' $@ | wc -l)
	total=$(     expr $bookmarks + $folders)

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
	bookmarks=$( grep '<A'  $file | wc -l)
	folders=$(   grep '<H3' $file | wc -l)
	total=$(     expr $bookmarks + $folders)

	echo $file $bookmarks $folders $total

done | column -t -N FILE,BOOKMARKS,FOLDERS,TOTAL

# Documentation is important!

: <<='cut'
=pod

=head1 NAME

count.sh - count your bookmark entries

=head1 SYNOPSIS

bash count.sh [options] <bookmark-file(s)>

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

=item B<-a>

This will give a cumulative total of the entries in all the files together
instead of processing each file individually.  The output will be as if only one
file was passed.  Note that [a] stands for [a]ggregate.

=back

=head1 EXIT STATUS

=over

=item 0 if okay

=item 1 if no positional arguments were supplied

=item 2 if a positional argument is invalid

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

#
