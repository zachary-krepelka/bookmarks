#!/usr/bin/env bash

# FILENAME: spellcheck.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, January 18th, 2024
# ABOUT: a bookmark spellchecking program
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Wednesday, May 22nd, 2024 at 2:06 AM

	# The purpose of this script is
	# to identify spelling mistakes
	# within bookmark entries.

usage() { program=$(basename $0); cat << EOF >&2
Usage: $program [option] <bookmark file>
spellcheck your bookmark entries on the command line

Options:

	-h		display this [h]elp message
	-i {file}	{file} is a list of words to [i]gnore
			It must begin with "personal_ws-1.1 en".

Documentation:  perldoc $PROG
Example:        bash $PROG bookmarks.html
EOF
exit 0
}

while getopts hi: option
do
	case $option in

		h) usage;;

		i)

			ignore_list=$OPTARG

			# Update the word count so the user doesn't have to

			word_count=$(expr $(wc -l < $ignore_list) - 1)

			sed -i "s/\(personal_ws-1.1 en \)\w*/\1$word_count/" $ignore_list

		;;

	esac
done

shift $((OPTIND-1))

if [[ $# -ne 1 ]]
then
	echo 'Exactly one argument is required. Try -h for help.' 1>&2
	exit 1
fi

set -f # disable globbing

while read line; do

	echo $line | grep -F --color=ALWAYS -f <( echo $line |
                                                             \
		aspell list ${ignore_list:+                  \
                                                             \
			--home-dir=$(dirname $ignore_list)   \
			--personal=$ignore_list              \
	})

done < <(sed -f - <(grep -Po '(?<=>)[^<]*(?=</A>)' $1) <<-EOF |

	s/&amp;/\&/g
	s/&lt;/</g
	s/&gt;/>/g
	s/&#39;/'/g
	s/&quot;/"/g

EOF
sort -u)

: <<='cut'
=pod

=head1 NAME

spellcheck.sh - spellcheck your bookmark entries

=head1 SYNOPSIS

bash spellcheck.sh <bookmark-file>

=head1 DESCRIPTION

The purpose of this script is to identify spelling mistakes within bookmark
entries.  The input is a file in the Netscape Bookmark file format.  The output
is a list of bookmark entries with spelling mistakes highlighted.

=head1 OPTIONS

=over

=item B<-h>

Display a [h]elp message and exit.

=item B<-i> I<FILE>

This flag specifies a file containing a list of words to [i]gnore.  The file
must begin with the string "personal_ws-1.1 en".

=back

=head1 NOTES

It may help to pipe the result into less with the -R flag, like this:

	bash spellcheck.sh bookmarks.html | less -R

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
