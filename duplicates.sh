#!/usr/bin/env bash

# FILENAME: duplicates.sh
# AUTHOR: Zachary Krepelka
# DATE: Monday, December 25th, 2023
# UPDATED: Saturday, March 23rd, 2024 at 1:30 PM

usage() { PROG=$(basename $0); cat << EOF >&2
Usage: $PROG [OPTION]... [FILE(S)]...
Identify duplicate entries in a bookmark file.

Options:
	-h	display this help message
	-i	enable case insensitivity
	-d	distinquish between files
	-s	switch from name to url
	-c	cut trailing slash

Example:

	$PROG -i bookmarks.html

Documentation:

	perldoc $PROG

EOF
exit 0
}

# VARIABLES

	TYPE=NAME
	REGEX='(?<=>)[^<]*(?=</A>)'

	CASE_INSENSITIVE=1
	REMOVE_TAIL=1
	DISTINCT=1
	ARGS=()

# COMMAND LINE ARGUMENT PARSING

	# Our program takes optional and positional arguments. This was helpful:

	# https://gist.github.com/caruccio/836c2dda2bdfa5666c5f9b0230978f26

	while [ $# -gt 0 ]; do

		while getopts hicds options; do

			case $options in

				h) usage;;

				i) CASE_INSENSITIVE=0;;

				c) REMOVE_TAIL=0;;

				d) DISTINCT=0;;

				s)
					TYPE=URL
					REGEX='(?<=HREF=")[^"]+'
				;;
			esac
		done

		[ $? -eq 0 ] || exit 1
		[ $OPTIND -gt $# ] && break

		shift $[$OPTIND - 1]
		OPTIND=1
		ARGS[${#ARGS[*]}]=$1
		shift
	done

	if [ ${#ARGS[*]} -lt 1 ]; then
		echo 'At least one argument is required. Try -h for help.' 1>&2
		exit 1
	fi

# CORE PROGRAM FUNCTIONALITY

	grep \
		--perl-regexp \
		--only-matching \
		--$(
			if [ $DISTINCT -eq 0 ]
			then
				echo with
			else
				echo no
			fi
		)-filename \
		$REGEX ${ARGS[*]} |
	\
	if [ $CASE_INSENSITIVE -eq 0 ]
	then
		tr '[:upper:]' '[:lower:]'
	else
		cat
	fi |
	\
	if [ $REMOVE_TAIL -eq 0 ] && [ "$TYPE" = "URL" ]
	then
		sed 's/\/$//'
	else
		cat
	fi |
	\
	sort | uniq -cd | sed 's/^\s*//' |
	\
	if [ $DISTINCT -eq 0 ]
	then
		sed 's/:/ /' | column -t -l 3 -N FREQ,FILE,$TYPE
		# Assumes that input filenames do not contain spaces.
	else
		column -t -l 2 -N FREQ,$TYPE
	fi

# DOCUMENTATION

: <<='cut'
=pod

=head1 NAME

duplicates.sh - identify duplicate entries in a bookmark file

=head1 SYNOPSIS

Below I describe the program's input, output, and usage.

=head2 Usage

bash duplicates.sh [options] [files]

=head2 Input

The input is one or more file in the Netscape Bookmark file format.  This file
format was originally created to store bookmarks for the Netscape web browser.
All major web browsers today use this standard to import and export bookmarks.
These files have the html extension with the HTML document type declaration
<!DOCTYPE NETSCAPE-Bookmark-file-1>.  They are usually called bookmarks.html by
default.

=head2 Output

The output is a formatted table to STDOUT.

=head1 DESCRIPTION

The purpose of this script is to identify duplicate bookmarks in a Netscape
bookmark file.  A bookmark entry entails its name and associated URL.  The
program can identify duplicates in each.

=head1 OPTIONS

There are five command-line options.  Any combination is viable. They can be
passed individually or all at once, e.g., passing -s -c -i versus passing -sci,
but they should be passed before the file arguments.

=head2 -h

Display a short [h]elp message and exit.

=head2 -i

Enable case [i]nsensitivity when determining if an entry is a duplicate.

=head2 -d

When multiple files are passed to the program, they are globed together by
default and regarded as one file; duplicates are identified across all the
files.  To [d]istinguish between files, pass the -d flag. An additional FILE
column will appear in the output. To demonstrate, imagine that the same entry
appears once in both file_1 and file_2.

	bash duplicates.sh file_1 file_2

		The entry is counted as a duplicate.

	bash duplicate.sh -d file_1 file_2

		The entry is not counted as a duplicate.

=head2 -s

A bookmark entry entails its name and associated URL.  This program can
identify duplicates in each. By default, it identifies duplicate bookmark
names. To identify duplicate URLs instead, use the [s]witch flag.

	bash duplicates.sh bookmarks.html

		Duplicate bookmark names are identified.

	bash duplicate.sh -s bookmarks.html

		Duplicate bookmark URLs are identified.

=head2 -c

Sometimes the only difference between two URLs is a trailing slash at the end.
To disregard the trailing slash when identifying duplicate URLs, pass the -c
flag to [c]ut the trailing slash. This only applies when the -s flag is passed.

=head1 EXAMPLE

Imagine that you bookmark three websites in your web browser.  (For this
example, I have chosen the world's three most popular websites according to an
online index.)

=over

=item * Google

=item * YouTube

=item * Reddit

=back

Suppose that you accidentally bookmark www.google.com twice.  (This is hard to
do with only three bookmarks, but imagine if you had hundreds or even thousands
of bookmarks spread out across many nested folders.)

Modern web browsers allow you to save your bookmarks by exporting them to a
file, typically called bookmarks_M_DD_YY.html.

In this example, we export our bookmarks and open the file in a text editor.
It will look something like this (but I've striped it down for simplicity):

	01 <!DOCTYPE NETSCAPE-Bookmark-file-1>
	02 <!-- This is an automatically generated file.
	03      It will be read and overwritten.
	04      DO NOT EDIT! -->
	05 <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
	06 <TITLE>Bookmarks</TITLE>
	07 <H1>Bookmarks</H1>
	08 <DL><p>
	09     <DT><H3 PERSONAL_TOOLBAR_FOLDER="true">Bookmarks bar</H3>
	10     <DL><p>
	11 	<DT><A HREF="https://www.google.com/">Google</A>
	12 	<DT><A HREF="https://www.google.com/">Google</A>
	13 	<DT><A HREF="https://www.youtube.com/">YouTube</A>
	14 	<DT><A HREF="https://www.reddit.com/">Reddit</A>
	15     </DL><p>
	16 </DL><p>

Observe lines 11 through 14, but in particular, pay attention to lines 11 and
12, which are duplicates of each other.  If we run our script on this file, it
will identify the duplicate.

	bash duplicates.sh bookmarks_M_DD_YY.html

		FREQ  NAME
		2     Google

	bash duplicates.sh -s bookmarks_M_DD_YY.html

		FREQ  URL
		2     https://www.google.com/

Our program does not alter the file.  Rather, the duplicate bookmark entry is
merely identified together with its number of occurrences.  The table will
probably be longer in a real-life use case.

Any number of situations are possible. There can exist duplicate bookmark
entries differing in name but not in URL, and vice versa. Case sensitivity is
also an important consideration. Use the command-line flags for different
outcomes.

=head1 CAVEATS

When using the -d flag, input filenames are assumed not to contain spaces.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
