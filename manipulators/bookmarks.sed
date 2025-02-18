#!/usr/bin/sed -f

# FILENAME: bookmarks.sed
# AUTHOR: Zachary Krepelka
# DATE: Monday, December 18th, 2023
# ABOUT: a script to tidy up your bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Tuesday, February 18th, 2025 at 5:19 PM

################################################################################

# POPULAR WEBSITES
s/ - Google Search//
s/ - Wikipedia//
s/ - YouTube//

# DICTIONARY WEBSITES
s/ - Wiktionary, the free dictionary//
s/ - Wiktionary//
s/ Definition &amp; Meaning - Merriam-Webster//

# QUESTION & ANSWER WEBSITES
s/ - Ask Different//
s/ - Ask Ubuntu//
s/ - Cross Validated//
s/ - MathOverflow//
s/ - Quora//
s/ - Server Fault//
s/ - Stack Overflow//
s/ - Super User//
s/ - TeX - LaTeX Stack Exchange//
s/ - [^-]* Stack Exchange//

# LATEX WEBSITES
s/ - LaTeX4technics//
s/ - Overleaf, Online LaTeX Editor//
s/ – TikZ\.net//

# TECH WEBSITES
/<A/ s/Learn \(.*\) in Y Minutes/WhereX=\1/
s/ - DEV Community//
s/ - GeeksforGeeks//
s/ - VimTricks//
s/ | Baeldung[^<]*//
s/ | DigitalOcean//
s/ | Enable Sysadmin//
s/ | Hacker News//
s/ | HackerNoon//

# SOFTWARE REPOSITORIES
s/ \xc2\xb7 PyPI//
s/CTAN: Package //
s/GitHub - \([^:]*\):[^<]*/\1/
s/APK for Android Download//

# OTHER
/medium\.com/ s/\([^>|]*\) | [^<]*/\1/
s/ - Wikibooks, open books for an open world//
s/ - wikiHow//

# URL CORRECTIONS
/quora/ s/?ch=[^"]*//
/youtube/ s/&list=[^"]*//
s/#:~:text=[^"]*//

################################################################################

# =pod
#
# =head1 NAME
#
# bookmarks.sed - a script to tidy up your bookmarks
#
# =head1 SYNOPSIS
#
#  sed -i -f bookmarks.sed bookmarks.html
#
# =head2 Instructions
#
# To use this script, follow these instructions.
#
# =over
#
# =item 1)
#
# Export your bookmarks from your web browser.
#
# =item 2)
#
# Run this script on the file.
#
# =item 3)
#
# Import the file back into your web browser and remove your previous bookmarks.
#
# =back
#
# =head2 Documentation
#
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' bookmarks.sed | pod2text | less
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' bookmarks.sed | pod2html | lynx -stdin
#
# =head1 DESCRIPTION
#
# The purpose of this script is to remove website taglines from bookmark
# entries.  When one bookmarks a website in a web browser, the entry for that
# bookmark's name is autofilled, usually with the page's title together with a
# tag that identifies the website.
#
# 	here is a bookmarked google search - Google Search
#
# The tagline is superfluous; the bookmark's favicon is already enough to
# identify the website.  Moreover, links originating from the same domain can be
# grouped into their own respective folders.  Removing the tag gives a clearer,
# uncluttered appearance.  It would be tedious to remove the extra text every
# time a bookmark is made, so a script will suffice instead.
#
# =head2 Manipulating URLs
#
# Clean up is also performed on URLs. Consider the anatomy of a URL.
#
# 	https://www.example.com:443/folder/document.html?lang=en#bottom
# 	\     / \             /  | \                   /\      /\     /
# 	 -----   -------------   |  -------------------  ------  -----
# 	   |           |         |           |             |       |
# 	   |           |         |           |             |       |
# 	   |           |         |           |             |       |
# 	   |           |         |           |             |       Fragment
# 	   |           |         |           |             |
# 	   |           |         |           |             Parameters
# 	   |           |         |           File Path
# 	   |           |         Port
# 	   |           Host
# 	   Protocol
#
# The parameters and fragments of a URL are often not worth saving.  Compare and
# contrast the following two links:
#
# 	https://www.merriam-webster.com/dictionary/effulgence
# 	https://www.merriam-webster.com/dictionary/effulgence#:~:text=radiant%20splendor
#
# The " #:~:text=... " highlights relevant text after following the link from a
# Google search.  This extra information is unnecessary.  Many other URLs
# contain similarly unnecessary information, which we can remove with regular
# expressions.
#
# =head1 NOTES
#
# Substitutions are largely performed on a case-by-case basis.  You may notice a
# general pattern: 'Page Title - Website Name'.  We could try to address the
# general situation by choosing a regex that splits on the delimiting character,
# then deleting the second half.  However, I have found that this does not
# generalize well; there are too many unpredictable matches and side effects, so
# I just prefer to match the many individual instances verbatim.  It's safer
# that way.
#
# =head1 TODO
#
# Here is a to-do list.
#
# =over
#
# =item
#
# Remove everything but the C<q> parameter from Google search URLs.  Bookmarked
# Google searches do not need to contain a bunch of query parameters.  Here is a
# demonstration.
#
# 	person@computer:~$ echo "$google_search_url" | sed 's/=[^&]*/=___/g'
# 	https://www.google.com/search?q=___&sca_esv=___&rlz=___&ei=___&ved=___&uact=___&oq=___&gs_lp=___&sclient=___
#
# =item
#
# Remove C<?lang=en> from various URLs, e.g., ones which automatically redirect
# to English.  L<https://ctan.org/> is one.
#
# =item
#
# Remove C<?ref=website> and C<?redirectfrom=...> parameters from URLs
#
# =item
#
# Remove possibly unwanted YouTube query parameters like timestamps and playlist
# indexes
#
# 	https://www.youtube.com/watch?v={id}&t={num}s
# 	https://www.youtube.com/watch?v={id}&list={id}&index={num}
#
# =back
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
