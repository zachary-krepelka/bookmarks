
# FILENAME: bookmarks.sed
# AUTHOR: Zachary Krepelka
# DATE: Monday, December 18th, 2023

# PURPOSE

	# The purpose of this script is to remove website taglines from bookmark
	# entries.  When one bookmarks a website in a web browser, the entry for
	# that bookmark's name is autofilled, usually with the page's title
	# together with a tag that identifies the website.

	#	here is a bookmarked google search - Google Search

	# The tagline is superfluous; the bookmark's favicon is already enough
	# to identify the website.  (Moreover, links originating from the same
	# domain can be grouped into their own respective folders.)

	# Removing the tag gives a clearer, uncluttered appearance.  It would be
	# tedious to remove the extra text every time a bookmark is made, so a
	# script will suffice instead.  Other clean up and maintenance is also
	# performed.

# INSTRUCTIONS

	# To use this script, follow these instructions.

	#	1) Export your bookmarks from your web browser.

	#	2) Run this script on the file.

	#	3) Export the file back into your web browser.
	#	   Remove your previous bookmarks.

# USAGE

	# sed -i -f bookmarks.sed bookmarks.html

# NOTE

	# This script uses the sed text editor.
	# For more information, see here:

		# https://www.gnu.org/software/sed/

# REMARK

	# I am continually adding to this file.
	# You may find it useful to add your own commands.

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

# OTHER
/medium\.com/ s/\([^>|]*\) | [^<]*/\1/
s/ - Wikibooks, open books for an open world//
s/ - wikiHow//

# REMARK

	# You may notice a general pattern:

	# 	Page Title - Website Name

	# You may think to address the more general situation by choosing a
	# regex that splits on the delimiting character, then deleting the
	# second half.  However, I've found that this does not generalize well;
	# there are too many unpredictable matches and side effects, so I just
	# prefer to match the many individual instances verbatim.

# URL CORRECTIONS

	# Sometimes URLs contain unnecessary information.  Case in point, compare
	# and contrast the following two links:

	#	https://www.merriam-webster.com/dictionary/effulgence

	#	https://www.merriam-webster.com/
	#		dictionary/effulgence#:~:text=radiant%20splendor

	# The " #:~:text=... " highlights relevant text after following the link
	# from a google search.  This extra information is unnecessary.  Many
	# other URLs contain similarly unnecessary information, which we can
	# remove with regular expressions.

/quora/ s/?ch=[^"]*//
/youtube/ s/&list=[^"]*//
s/#:~:text=[^"]*//

# TODO

	# remove ?lang=en from ctan.org urls
	# remove ?ref=website from Merriam-Webster urls
