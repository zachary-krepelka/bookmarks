# bookmarks

Scripts for bookmark management by Zachary Krepelka

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, January 4th, 2024
	ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
	UPDATED: Sunday, February 16th, 2025 at 10:02 PM
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
the file in a text editor.  **The programs in this repository either operate on
or generate these files.**

## Procedure

Each file in this repository stands on its own as a self-contained command-line
application.  Follow this general procedure to use a program in this repository.
The procedure will vary from script to script, and there are some exceptions,
but this is the general course of action.

1. Export your bookmarks from your web browser to a file, say `bookmarks.html`.

2. Run the program on that file.  Here's what can happen.

	- The program generates an informational report without changing the
	  file.

	- The program modifies the file, either in place or by outputting an
	  altered copy.

3. If the program changes the file, import the modified file back into your web
   browser and remove your previous bookmarks.

Note that it's often only useful to run these scripts on a *subset of your
bookmarks*.  The bookmark managers built into modern web browsers do not make it
easy to export a subset of your bookmark collection, but this is indeed
possible.  Various strategies are explored in response to [this question][7] on
Super User.

## Documentation

The scripts in this repository are thoroughly documented using the [pod][8]
markup language.  The documentation that I write is *user facing*.  It does not
attempt to explain how the code works, only how it can be used.  To understand
what a script does, your first step is to pass the `-h` flag to that script on
the command line to receive help.  Your second step is to read that script's
documentation by passing the name of the script to the `perldoc` command.  Below
is an example.

```bash
bash script.sh -h   # quick help
perldoc script.sh   # documentation
```

While pod originates with Perl, it is a freestanding markup language that can be
used in contexts outside of Perl, so please don't feel uncomfortable typing
something like `perldoc bookmarks.ahk` for example.  Where it is impossible to
document a script in this fashion, the documentation is instead provided in the
source code as comments.

## Functionality

The functionality of each script is summarized in the table below.

<div align="center">

|  Program                      | Functionality                                |
| ----------------------------- | -------------------------------------------- |
| 80.sh                         | Reports bookmark names over 80 characters    |
| alphabetize.pl                | Organize bookmarks alphabetically            |
| bookmarkleter.pl              | Packages JavaScript into a bookmark file     |
| bookmarklets.js               | Showcases a few of my [bookmarklets][9]      |
| bookmarks.ahk                 | Enhances bookmarking UI for Google Chrome    |
| bookmarks.sed                 | Removes superfluous textual patterns         |
| count.sh                      | Counts the number of bookmarks and folders   |
| domainify.pl                  | Organize bookmarks by website                |
| domains.sh                    | Reports domain frequencies                   |
| duplicates.sh                 | Identifies duplicate bookmark entries        |
| favicon.sh                    | Repopulates missing bookmark [favicons][10]  |
| pancake.pl                    | Flatten nested bookmarks                     |
| search.pl                     | Search your bookmarks on the command line    |
| skeleton.pl                   | Strip bookmarks leaving only folders         |
| sort.pl                       | Sort bookmarks in folders recursively        |
| spellcheck.sh                 | Reports spelling mistakes in bookmark names  |
| tabgroups-to-bookmarks.pl     | Data converter targeting a Chrome extension  |
| tabgroups-to-bookmarks.jq     | Same thing but input is json instead of html |
| treeifier.pl                  | Creates [tree view][11] from bookmark file   |
| wrangle.pl                    | Wrangle up misplaced bookmarks               |
| youtube-thumbnail-scraper.sh  | Download YouTube thumbnails in bulk          |

</div>

## Related / Recommended Software

I use the following software in conjunction with the scripts in this repository.

* The [Kiwi Browser][12] is a fully open-source, Chromium-based web browser for
  the Android operating system.  It supports the ability to import and export
  bookmarks to and from an HTML file in the Netscape bookmark file format.
  Neither Chrome nor Firefox support this feature in their mobile applications,
  instead requiring the user to sync their bookmarks using an online account.

* The [Selective Bookmarks Export Tool][13] is a web browser extension available
  for Chrome, Firefox, and Edge.

  > It allows users to choose the bookmarks they want to export as [an] HTML
  > file, to decide the data structure of the exported content, and to filter
  > the results by keywords when selecting bookmarks.

* The [Firefox Bookmark Backup Decompressor][14] is an online web app that can
  decompress bookmark backup files created by the Firefox web browser.  This app
  is your friend in a last-ditch data recovery effort.

<!-- References -->

[1]: https://en.wikipedia.org/wiki/Bookmark_(digital)
[2]: https://en.wikipedia.org/wiki/Personal_information_management
[3]: https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa753582(v=vs.85)
[4]: https://en.wikipedia.org/wiki/Netscape
[5]: https://en.wikipedia.org/wiki/Data_portability
[6]: https://en.wikipedia.org/wiki/Interoperability
[7]: https://superuser.com/questions/128242/how-to-export-an-individual-bookmark-folder-in-google-chrome
[8]: https://en.wikipedia.org/wiki/Plain_Old_Documentation
[9]: https://en.wikipedia.org/wiki/Bookmarklet
[10]: https://en.wikipedia.org/wiki/Favicon
[11]: https://en.wikipedia.org/wiki/Tree_view
[12]: https://kiwibrowser.com
[13]: https://github.com/LightAPIs/free-export-bookmarks
[14]: https://www.jeffersonscher.com/ffu/bookbackreader.html
