#!/usr/bin/env bash

# FILENAME: spellcheck.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024
# ABOUT: a bookmark spellchecking program
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, September 18th, 2025 at 7:01 PM

# Functions --------------------------------------------------------------- {{{1

program="${0##*/}"

usage() {
	cat <<-USAGE
	Spellcheck your bookmark entries on the command line

	Usage:
	  bash $program [options] <netscape-bookmark-file>

	Options:
	  -h       display this [h]elp message and exit
	  -H       read documentation for this script then exit
	  -i FILE  line-by-line list of words to [i]gnore
	           FILE must begin with "personal_ws-1.1 en"
	  -p ARGS  [p]ass ARGS to aspell
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

	local dependencies=(
		aspell cat dirname expr grep
		less pod2text sed sort wc
	)

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

while getopts hHi:p: option
do
	case "$option" in

		h) usage;;
		H) documentation;;
		i)
			ignore_list="$OPTARG"

			# Update the word count so the user doesn't have to

			word_count="$(expr $(wc -l < "$ignore_list") - 1)"

			sed -i "s/\(personal_ws-1.1 en\) \?\w*/\1 $word_count/" $ignore_list
		;;

		p) args="$OPTARG";;
	esac
done

shift "$((OPTIND - 1))"

if test $# -ne 1
then error 2 'Exactly one argument is required. Try -h for help.'
fi

# Processing -------------------------------------------------------------- {{{1

set -f # disable globbing

# TODO quoting, escaping, and reading need addressed.

{
	while read line; do

		echo $line | grep -F --color=ALWAYS -f <( echo $line |
								     \
			aspell $args list ${ignore_list:+            \
								     \
				--home-dir=$(dirname $ignore_list)   \
				--personal=$ignore_list              \
		})

	done < <(sed -f - <(grep -Po '(?<=>)[^<]*(?=</A>)' $1) <<-'EOF' |

		# TODO outsource HTML decoding to an external program
		# TRY perl -MHTML::Entities -pe 'decode_entities($_);'

		s/&amp;/\&/g
		s/&lt;/</g
		s/&gt;/>/g
		s/&#39;/'/g
		s/&quot;/"/g

	EOF
	sort -u)

} | less -FRS

# Documentation ----------------------------------------------------------- {{{1

# https://charlotte-ngs.github.io/2015/01/BashScriptPOD.html
# http://bahut.alma.ch/2007/08/embedding-documentation-in-shell-script_16.html

: <<='cut'
=pod

=head1 NAME

spellcheck.sh - a bookmark spellchecker

=head1 SYNOPSIS

bash spellcheck.sh [options] <netscape-bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to identify spelling mistakes within bookmark
entries.  The input is a file in the Netscape Bookmark file format.  The output
is a list of bookmark entries with spelling mistakes highlighted.

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

=item B<-i> I<FILE>

This flag specifies a file containing a list of words to [i]gnore.  The file
must begin with the string "personal_ws-1.1 en".

=item B<-p> I<ARGS>

This script is ultimately just a wrapper around the command-line program aspell.
This option allows you to [p]ass arbitrary arguments to aspell.  Consult the
manual by typing C<man aspell>.

=back

=head1 DIAGNOSTICS

The program exits with the following status codes.

=over

=item 0 if okay

=item 1 if dependencies are missing

=item 2 if the wrong number of positional arguments are supplied

=back

=head1 NOTES

To ignore case, use this:

	bash spellcheck.sh -p '--ignore-case' bookmarks.html

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

# vim: tw=80 ts=8 sw=8 noet fdm=marker
