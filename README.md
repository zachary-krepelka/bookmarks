# bookmarks

Scripts for bookmark management by Zachary Krepelka

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, January 4th, 2024
	ORIGIN: https://github.com/zachary-krepelka/bookmarks
	UPDATED: Saturday, March 30th, 2024 at 1:10 AM
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

A digital bookmark stores the address for a website on your computer so that you
can easily return to that web page later.  Modern web browsers allow you to save
your bookmarks by importing and exporting them to a file, typically called
`bookmarks.html`.  These files adhere to the [Netscape Bookmark file format][3].
This file format was originally created to store bookmarks for the [Netscape][4]
web browser, but all major web browsers today have adopted this standard,
therein promoting [data portability][5] and [interoperability][6] between
browsers.  These files have the `.html` extension with the HTML document type
declaration `<!DOCTYPE NETSCAPE-Bookmark-file-1>`, which can be seen by opening
the file in a text editor.  **The programs in this repository operate on these
files.**

## Procedure

Each program serves a different purpose.  Follow this general procedure to use
a program in this repository.

1. Export your bookmarks from your web browser to a file, say `bookmarks.html`.

2. Run the program on that file.  Here's what can happen.

	- The program generates an informational report without changing the
	  file.

	- The program modifies the file, either in place or by outputting an
	  altered copy.

3. If the program changes the file, import the modified file back into your web
   browser and remove your previous bookmarks.

The procedure will vary from script to script, and there are some exceptions,
but this is the general course of action.

## Documentation

The scripts in this repository are thoroughly documented.  To understand what a
script does, your first step is to pass the `-h` flag to that script on the
command line to receive help.  Your second step is to read that script's
documentation by passing the name of the script to the `perldoc` command.  Below
is an example.

```bash
bash script.sh -h   # quick help
perldoc script.sh   # documentation
```

Where it is impossible to document a script in this fashion, the documentation
is instead provided in the source code as comments.

## Functionality

The functionality of each script is summarized in the table below.

|  Program          | Functionality                               |
| ----------------- | ------------------------------------------- |
| 80.sh             | Reports bookmark names over 80 characters   |
| bookmarkleter.pl  | Packages JavaScript into a bookmark file    |
| bookmarklets.txt  | Showcases a few of my [bookmarklets][7]     |
| bookmarks.sed     | Removes superfluous textual patterns        |
| count.sh          | Counts the number of bookmarks and folders  |
| duplicates.sh     | Identifies duplicate bookmark entries       |
| favicon.sh        | Repopulates missing bookmark [favicons][8]  |
| spell-check.sh    | Reports spelling mistakes in bookmark names |
| treeifier.pl      | Creates [tree view][9] from bookmark file   |

<!-- References -->

[1]: https://en.wikipedia.org/wiki/Bookmark_(digital)
[2]: https://en.wikipedia.org/wiki/Personal_information_management
[3]: https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa753582(v=vs.85)
[4]: https://en.wikipedia.org/wiki/Netscape
[5]: https://en.wikipedia.org/wiki/Data_portability
[6]: https://en.wikipedia.org/wiki/Interoperability
[7]: https://en.wikipedia.org/wiki/Bookmarklet
[8]: https://en.wikipedia.org/wiki/Favicon
[9]: https://en.wikipedia.org/wiki/Tree_view
[10]: https://stackoverflow.com/questions/72772176/documentation-or-reference-for-netscape-bookmark-file-1-doctype
[11]: http://fileformats.archiveteam.org/wiki/Netscape_bookmarks
