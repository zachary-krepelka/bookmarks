#!/usr/bin/sed -f

# FILENAME: bookmarks.sed
# AUTHOR: Zachary Krepelka
# DATE: Monday, December 18th, 2023
# ABOUT: a script to tidy up your bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Monday, April 1st, 2024 at 2:31 PM

################################################################################

# USAGE

	# sed -i -f bookmarks.sed bookmarks.html

# PURPOSE

	# The purpose of this script is to remove website taglines from bookmark
	# entries.  When one bookmarks a website in a web browser, the entry for
	# that bookmark's name is autofilled, usually with the page's title
	# together with a tag that identifies the website.

		# here is a bookmarked google search - Google Search

	# The tagline is superfluous; the bookmark's favicon is already enough
	# to identify the website.  (Moreover, links originating from the same
	# domain can be grouped into their own respective folders.)

	# Removing the tag gives a clearer, uncluttered appearance.  It would be
	# tedious to remove the extra text every time a bookmark is made, so a
	# script will suffice instead.

	# Clean up is also performed on URLs. Consider the anatomy of a URL.

	# https://www.example.com:443/folder/document.html?lang=en#bottom
	# \     / \             /  | \                   /\      /\     /
	#  -----   -------------   |  -------------------  ------  -----
	#    |           |         |           |             |       |
	#    |           |         |           |             |       |
	#    |           |         |           |             |       |
	#    |           |         |           |             |       Fragment
	#    |           |         |           |             |
	#    |           |         |           |             Parameters
	#    |           |         |           File Path
	#    |           |         Port
	#    |           Host
	#    Protocol

	# The parameters and fragments of a URL are often not worth saving.
	# Compare and contrast the following two links:

		# https://www.merriam-webster.com/dictionary/effulgence

		# https://www.merriam-webster.com/
		#	dictionary/effulgence#:~:text=radiant%20splendor

	# The " #:~:text=... " highlights relevant text after following the link
	# from a google search.  This extra information is unnecessary.  Many
	# other URLs contain similarly unnecessary information, which we can
	# remove with regular expressions.

# INSTRUCTIONS

	# To use this script, follow these instructions.

	#	1) Export your bookmarks from your web browser.

	#	2) Run this script on the file.

	#	3) Import the file back into your web browser.
	#	   Remove your previous bookmarks.

# NOTE

	# This script uses the sed text editor.
	# For more information, see here:

		# https://www.gnu.org/software/sed/

# REMARK

	# You may notice a general pattern:

	# 	Page Title - Website Name

	# You may think to address the more general situation by choosing a
	# regex that splits on the delimiting character, then deleting the
	# second half.  However, I've found that this does not generalize well;
	# there are too many unpredictable matches and side effects, so I just
	# prefer to match the many individual instances verbatim.

# QUESTION

	# Does anyone know if sed scripts support block comments?

	# Here's what I've tried.

		# FILENAME: script.sed
		# --------------------
		# 1  s/foo/bar/
		# 2  s/baz/quuz/
		# 3  q
		# 4
		# 5  =head1 NAME
		# 6
		# 7  script.sed - an attempt to document a sed script

	# I tried devising a way to embed Perl POD into a sed script.  The man
	# page for sed says that the q command "immediately quits the sed script
	# without processing any more input."

		# sed -f script.sed file.txt

	# But when I run the above command, sed still quits with an error on
	# line 5. It would be nice if there was some hack to make this work.

	# The only solution that I can think of is to create a shell wrapper
	# around a sed script, but that's undesirable.

		# FILENAME: sed-script.sh
		# -----------------------
		# 01  #!/usr/bin/env bash
		# 02
		# 03  sed -f - <<-EOF $1
		# 04
		# 05  s/foo/bar/
		# 06  s/baz/quuz/
		# 07
		# 08  EOF
		# 09
		# 10  : <<='cut'
		# 11  =pod
		# 12
		# 13  =head1 NAME
		# 14
		# 15  sed-script.sh - a shell wrapper around a sed script.
		# 16
		# 17  =head1 SYNOPSIS
		# 18
		# 19  bash sed-script.sh [input file] > [output file]
		# 20
		# 21  =head1 DESCRIPTION
		# 22
		# 23  This is a demonstration of how to document a sed script.
		# 24
		# 25  =cut
		# 26

# TODO

	# remove ?lang=en from ctan.org urls
	# remove ?ref=website from Merriam-Webster urls
	# remove ?redirectfrom=... parameters

	# remove YouTube time stamps

		# https://www.youtube.com/watch?v={stuff}&t={num}s

	# remove YouTube playlist indexes

		# https://www.youtube.com/watch?v={str}&list={str}&index={num}

################################################################################

#  _           _
# /  _  _| _  |_) _  _ o._  _ |_| _ .__
# \_(_)(_|(/_ |_)(/_(_||| |_> | |(/_|(/_
#                    _|

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
