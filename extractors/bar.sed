#!/usr/bin/env -S sed -nf

# FILENAME: bar.sed
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, September 17th, 2025
# ABOUT: extract bookmarks on the bookmarks bar
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Friday, September 19th, 2025 at 1:27 AM

1,/^<DL><p>/p
/PERSONAL_TOOLBAR_FOLDER/,/^ \{4\}<\//{
	/^ \{8\}<DT><A/{
		s/^ \{4\}//
		p
	}
}
$a</DL><p>

# =pod
#
# =head1 NAME
#
# bar.sed - extract bookmarks on the bookmarks bar
#
# =head1 SYNOPSIS
#
#  sed -nf bar.sed <netscape-bookmark-file>
#
# =head2 Documentation
#
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' bar.sed | pod2text | less
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' bar.sed | pod2html | lynx -stdin
#
# =head1 DESCRIPTION
#
# Objective: given a Netscape bookmark file INPUT, to produce a Netscape
# bookmark file OUTPUT containing only the bookmarks which would appear
# on the bookmarks bar for INPUT.  In other words, this script strips
# out folders on the bookmarks bar as well as folders "outside" the
# bookmarks bar, e.g., the "Other Bookmarks" and "Bookmarks Menu"
# folders.
#
# =head1 NOTES
#
# To elaborate on the need, imagine that you have a large collection of
# bookmarks neatly organized into a hierarchy of folders.  In the course
# of everyday life, it is tedious to file a bookmark into this structure
# at the time of creation, so you fall into the habit of haphazardly
# bookmarking web pages with the intent of organizing them later.  Their
# storage location defaults to the bookmarks bar.  Before you know it,
# your bookmarks bar fills up with clutter and eventually spills over
# into an overflow menu marked by a double-chevron >>.
#
# The need is now apparent.  By extracting the clutter, and only the
# clutter, we can use computer programs to process and organize that
# data, whereafter we can integrate it back into our larger structure.
#
# =head1 SEE ALSO
#
# This script is part of my GitHub repository.
#
# 	https://github.com/zachary-krepelka/bookmarks.git
#
# This repository contains various scripts for bookmark management.
#
# =head1 AUTHOR
#
# Zachary Krepelka L<https://github.com/zachary-krepelka>
#
# =cut
