# Bookmarks Bar Enumerator

A Chrome Extension to Enumerate Items on the Bookmarks Bar

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, September 25th, 2025
	ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
-->

## Overview

Clicking this extension's icon will rename all items on the bookmarks bar so
that they are numbered starting from zero.

```text
Before
.----------------------------------------------------------------------.
| # Google # YouTube # Facebook # Instagram          # Other Bookmarks |
.----------------------------------------------------------------------.

After
.----------------------------------------------------------------------.
| # 0 # 1 # 2 # 3                                    # Other Bookmarks |
.----------------------------------------------------------------------.
```

Note that only items on the bookmarks bar are affected.  Folders on the
bookmarks bar are renamed, but their contents--either bookmarks or
subfolders--are not renamed.  Likewise, the "Other Bookmarks" folder is left
alone.

## Purpose

This extension was programmed to be used in conjunction with
[`bookmark-motions.ahk`][1], an AutoHotkey script which provides Vim motions for
bookmark management.  That script imposes a keyboard-centric, modal interface
with two modes.

1. In standard mode, the bookmark bar is hidden, and the web browser behaves
   normally.

2. In bookmarking mode, the bookmarks bar becomes visible, and focus is
   redirected to it. Here, special commands can be used to navigate the
   bookmarks bar and its drop-down menus. The user can also perform common
   operations like cut, copy, paste, and delete.

A leader key is provided to switch between the two modes.  When the user enters
bookmarking mode, a focus ring is positioned over the first item on the
bookmarks bar.  Employing standard VI keybindings, the user can type for example
`7l` to navigate to the seventh item to the right of the first item.  This makes
for a quick way to access items on the bookmarks bar in a keyboard-centric
manner.

To make it easier to ascertain the number of an item on the bookmarks bar, we
can--unsurprisingly--number them. The title of a bookmark is usually not needed
since its favicon is already enough to identify it.  The issue of identification
still remains for folders, which do not have unique favicons.  I prefer to nest
all of my folders under a single, root folder on the bookmarks bar where they
are unaffected by the rename. The rest of the bookmarks bar is then reserved for
frequently accessed bookmarks.

Renaming bookmarks in this manner is tedious to do manually, hence the purpose
of this extension.

 ## Installation

1. Clone this repository and extract this subdirectory.
2. Create the icons for this extension by running `generate-placeholder-icons.sh`.
3. Load the extracted directory in Chrome as an unpacked extension.
4. Click the extension icon. The bookmarks bar will be enumerated.

[1]: https://github.com/zachary-krepelka/bookmarks/blob/main/user-interface/bookmark-motions.ahk
