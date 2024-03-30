#!/usr/bin/env bash

# FILENAME: domains.sh
# AUTHOR: Zachary Krepelka
# DATE: Saturday, March 30th, 2024
# ORIGIN: https://github.com/zachary-krepelka/bookmarks

usage() { PROG=$(basename $0); cat << EOF >&2
Usage: $PROG [options] <file>
analyze domain frequencies in a bookmark file

Options:
	-h	display this help message
	-m NUM	minimum freqeuncy to appear

Documentation: perldoc $PROG
Example:       bash $PROG bookmarks.html
EOF
exit 0
}

[ "$1" == "--help" ] && usage

MIN=0

while [ $# -gt 0 ]; do

	while getopts hm: options; do

		case $options in

			h) usage;;

			m) MIN=$OPTARG;;
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

URLS=$(grep -oP '(?<=HREF=")[^"]+' ${ARGS[*]})

for domain in $(grep -oP '(?<=:\/\/)[^\/]+' <(echo "$URLS") | sort -u)
do
	NUM=$(grep -F "://$domain" <(echo "$URLS") | wc -l)

	if [[ $NUM -lt $MIN ]]
	then
		continue
	fi

	echo "$NUM $domain"

done | column -t -N FREQ,DOMAIN

: <<='cut'
=pod

=head1 NAME

domains.sh - analyze domain frequencies in a bookmark file

=head1 SYNOPSIS

bash domains.sh [options] <bookmark file>

=head1 DESCRIPTION

The purpose of this script is to analyze domain frequencies in a bookmark file.
The input is a file in the Netscape bookmark file format. The output is a
formatted table to STDOUT. The table reports each unqiue domain in the file
together with the frequency of bookmark entries belonging to that domain.

=head1 OPTIONS

=over

=item B<-h>

Display a help message.

=item B<-m> I<NUM>

Specifies the minimum frequency to appear in the output.
This allows the user to filter out one-off domains.

	bash domains.sh -m 10 bookmarks.html > double-digits-and-up.txt

	bash domains.sh -m 100 bookmarks.html > triple-digits-and-up.txt

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

#
