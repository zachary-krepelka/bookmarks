# bookmarks

Scripts for bookmark management

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, January 4th, 2024
-->

# Motivations

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

# Overview

Each script works independently.  Here's an overview of what they do:

|  File                 | Functionality                              |
| --------------------- | ------------------------------------------ |
| bookmarklet-parser.pl | Packages JavaScript into a bookmark file   |
| bookmarklets.txt      | Showcases a few of my [bookmarklets][3]    |
| bookmarks.sed         | Removes superfluous textual patterns       |
| count.sh              | Counts the number of bookmarks and folders |
| duplicates.sh         | Identifies duplicate bookmark entries      |
| favicon.sh            | Repopulates missing bookmark [favicons][4] |

<!-- References -->

[1]: https://en.wikipedia.org/wiki/Bookmark_(digital)
[2]: https://en.wikipedia.org/wiki/Personal_information_management
[3]: https://en.wikipedia.org/wiki/Bookmarklet
[4]: https://en.wikipedia.org/wiki/Favicon
