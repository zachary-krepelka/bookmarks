# bookmarks

Scripts for bookmark management by Zachary Krepelka

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, January 4th, 2024
	ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
	UPDATED: Tuesday, February 18th, 2025 at 2:03 AM
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

The functionality of each script is summarized below.

<!--
person@computer:~$ cat tree.sed
/^```graphql$/,/^```$/{
	/^```$/etree -I tree.sed -F --info --noreport --charset=ascii | tr '[' '#'
	/^```/p
	d
}
person@computer:~$ sed -f tree.sed README.md | sponge README.md
-->

```graphql
./
|-- README.md
|    # you should read this
|-- analyzers/
|    # scripts that generate informational reports
|   |-- 80.sh
|   |    # reports bookmark names over 80 characters
|   |-- count.sh
|   |    # counts the number of bookmarks and folders
|   |-- domains.sh
|   |    # reports domain frequencies
|   |-- duplicates.sh
|   |    # identifies duplicate bookmark entries
|   |-- search.pl
|   |    # search your bookmarks on the command line
|   |-- spellcheck.sh
|   |    # reports spelling mistakes in bookmark names
|   `-- wrangle.pl
|        # wrangle up misplaced bookmarks
|-- categorizers/
|    # scripts that categorize data
|   |-- alphabetize.pl
|   |    # organize bookmarks alphabetically
|   `-- domainify.pl
|        # organize bookmarks by website
|-- converters/
|    # scripts that convert between file formats
|   |-- bookmarkleter.pl
|   |    # packages JavaScript into a bookmark file
|   |-- tabgroups-to-bookmarks.jq
|   |    # data converter targeting a Chrome extension
|   |-- tabgroups-to-bookmarks.pl
|   |    # same thing but input is html instead of json
|   `-- treeifier.pl
|        # creates treeview from bookmark file
|-- manipulators/
|    # scripts that perform fine-grained modifications
|   |-- bookmarks.sed
|   |    # removes superfluous textual patterns
|   |-- favicon.sh
|   |    # repopulates missing bookmark favicons
|   |-- pancake.pl
|   |    # flatten nested bookmarks
|   |-- skeleton.pl
|   |    # strip bookmarks leaving only folders
|   `-- sort.pl
|        # sort bookmarks in folders recursively
`-- misc/
     # scripts that are miscellaneous
    |-- bookmarklets.js
    |    # showcases a few of my bookmarklets
    |-- bookmarks.ahk
    |    # enhances bookmarking ui for Google Chrome
    `-- youtube-thumbnail-scraper.sh
         # download YouTube thumbnails in bulk
```

<!-- https://github.com/DavidWells/advanced-markdown?tab=readme-ov-file#nice-looking-file-tree -->

## Related / Recommended Software

I use the following software in conjunction with the scripts in this repository.

* The [Kiwi Browser][9] is a fully open-source, Chromium-based web browser for
  the Android operating system.  It supports the ability to import and export
  bookmarks to and from an HTML file in the Netscape bookmark file format.
  Neither Chrome nor Firefox support this feature in their mobile applications,
  instead requiring the user to sync their bookmarks using an online account.

* The [Selective Bookmarks Export Tool][10] is a web browser extension available
  for Chrome, Firefox, and Edge.

  > It allows users to choose the bookmarks they want to export as [an] HTML
  > file, to decide the data structure of the exported content, and to filter
  > the results by keywords when selecting bookmarks.

* The [Firefox Bookmark Backup Decompressor][11] is an online web app that can
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
[9]:  https://kiwibrowser.com
[10]: https://github.com/LightAPIs/free-export-bookmarks
[11]: https://www.jeffersonscher.com/ffu/bookbackreader.html
