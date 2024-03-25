# bookmarks

Scripts for bookmark management by Zachary Krepelka

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, January 4th, 2024
	ORIGIN: https://github.com/zachary-krepelka/bookmarks
	UPDATED: Monday, March 25th, 2024 at 4:49 AM
-->

## Motivations

I use my [bookmarks][1] to keep track of almost everything in my life.  *They
are important to me.*  I have a large number of them carefully organized into a
categorical hierarchy of nested folders.  This constitutes my [personal
information management][2] system.  Every book, movie, song, painting, or media
form broadly *that I've experienced* is noted along with a web link documenting
it, e.g., to an online encyclopedia.  This allows me to store, organize,
maintain, retrieve, remember, and otherwise interact with information over long
periods of time.  I use this system to manage my knowledge base as a student.
Quoting the linked article:

> A person's perception of and ability to effect change in the world is
> determined, constrained, and sometimes greatly extended, by an ability to
> receive, send and otherwise manage information.

To help with the management of my bookmarks, I've written a number of computer
scripts.  I hope that others can benefit from them too.  People with hundreds or
even thousands of bookmarks will find this repository useful.

## Overview

A digital bookmark is "an address for a website stored on a computer so that the
user can easily return to the site" ([Collins Dictionary)][5]).  Modern web
browsers allow you to save your bookmarks by exporting them to a file, typically
called `bookmarks.html`.  These files adhere to the [Netscape Bookmark file
format][6].  **The programs in this repository operate on these files.**

This file format was originally created to store bookmarks for the Netscape web
browser, but all major web browsers today have adopted this standard.  These
files have the extension `.html` and the HTML document type declaration
`<!DOCTYPE NETSCAPE-Bookmark-file-1>`, which can be seen by opening the file in
a text editor.

## Procedure

Each program serves a different purpose.  Follow this general procedure to use
a program in this repository.

1. Export your bookmarks from your web browser to a file, say `bookmarks.html`.

2. Run the program on that file. Here's what can happen.

	- The program generates an informational report without changing the
	  file.

	- The program modifies the file, either in place or by outputting an
	  altered copy.

3. If the program changes the file, import the modified file back into your web
   browser and remove your previous bookmarks.

The procedure will vary from script to script, and there are some exceptions,
but this is the general course of action.

## Documentation

The scripts are extensively documented wherever possible[^1]. To understand
what a script does, your first step is to pass the `-h` flag on the command
line to receive help. Your second step is to read the documentation by typing
`perldoc THE_PROGRAM_YOU_WANT_HELP_WITH`.  I use the POD markup language for
documentation, which was originally devised for the Perl programming language,
although it can be used elsewhere, like I do here for bash scripts. POD
documentation is read using the `perldoc` command.  You can also read the
documentation in other formats by using conversion tools like `pod2man`,
`pod2pdf`, and `pod2html`.

<div align="center">

|  Program          | Functionality                               |
| ----------------- | ------------------------------------------- |
| bookmarkleter.pl  | Packages JavaScript into a bookmark file    |
| bookmarklets.txt  | Showcases a few of my [bookmarklets][3]     |
| bookmarks.sed     | Removes superfluous textual patterns        |
| count.sh          | Counts the number of bookmarks and folders  |
| duplicates.sh     | Identifies duplicate bookmark entries       |
| favicon.sh        | Repopulates missing bookmark [favicons][4]  |
| 80.sh             | Reports bookmark names over 80 characters   |
| spell-check.sh    | Reports spelling mistakes in bookmark names |

</div>

<!-- Footnotes -->

[^1]: Actually, I'm still working on the documentation.

<!-- References -->

[1]: https://en.wikipedia.org/wiki/Bookmark_(digital)
[2]: https://en.wikipedia.org/wiki/Personal_information_management
[3]: https://en.wikipedia.org/wiki/Bookmarklet
[4]: https://en.wikipedia.org/wiki/Favicon
[5]: https://www.collinsdictionary.com/us/dictionary/english/bookmark
[6]: https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa753582(v=vs.85)
[7]: https://stackoverflow.com/questions/72772176/documentation-or-reference-for-netscape-bookmark-file-1-doctype
[8]: http://fileformats.archiveteam.org/wiki/Netscape_bookmarks
