;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FILENAME: bookmark-motions.ahk
; AUTHOR: Zachary Krepelka
; DATE: Friday, March 8th, 2024
; ABOUT: Vim motions for bookmark management
; ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
; UPDATED: Monday, April 14th, 2025 at 2:19 AM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; | \ _  _   ._ _  _ .__|_ _._|_o _ ._
; |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

/*
=pod

=head1 NAME

bookmark-motions.ahk - Vim motions for bookmark management

=head1 SYNOPSIS

Using the Windows Command Prompt:

 Invocation:  start bookmark-motions.exe
 Termination: taskkill /IM bookmark-motions.exe
 Compilation: Ahk2Exe.exe /in bookmark-motions.ahk /out bookmark-motions.exe

The compiler can be obtained at L<https://github.com/AutoHotkey/Ahk2Exe.git>

=head1 DESCRIPTION

The purpose of this script is to provide an enhanced user interface method for
working with one's bookmarks in various web browsers.  This script aims to
provide a Vim-like, keyboard-centric experience for bookmark management,
allowing the user to manage their bookmarks without the use of a mouse.

The supported web browsers are listed below.

=over

=item Google Chrome

=item Microsoft Edge

=item Mozilla Firefox

=item Opera & Opera GX

=back

Because this script is written with AutoHotkey, it will only run on Windows
operating systems (so Safari is a no-go), but one day I intend to write a port
for Linux.

=head2 Usage

There are two modes: standard mode and bookmarking mode.  When the user is in
standard mode, the web browser will behave as expected; but when the user is in
bookmarking mode, the behavior of the mouse and the keyboard is changed to make
it less difficult to interact with bookmarks and their drop-down menus.  Focus
is redirected to the bookmark bar where special navigation commands can be used.

	.-------------.
	| Work        |
	| Personal  >-|---------------.
	.-------------.  | Reading    |
	                 | Leisure    |
	                 | Social     |
	                 | Finance    |
	                 | Shopping   |
	                 | Recipes  >-|--------------------------.
	                 | News       |  | Chocolate Chip Cookie |
	                 .------------.  | Angel food cake       |
	                                 | Tiramisu              |
	                                 .-----------------------.

To toggle between the two modes, press backslash twice in quick succession.  An
audible beep will sound to indicate that the key press was registered.  While in
bookmarking mode, the bookmark bar is visible.  Otherwise, it is hidden.  This
keeps your workspace looking clean and uncluttered.

=head1 KEYBINDINGS

=head2 Bookmarking Mode

The following keyboard shortcuts are available when bookmarking mode is active.
These keybindings are largely vim-inspired, meaning that you will use hjkl
instead of the arrow keys.

	  k
	h   l
	  j

Some keybindings are not supported on all web browsers. Refer to the section
titled COMPATIBILITY for more details.

=over

=item B<j>

Move down.  Used for scrolling through drop-down menus.  When prefixed
with a number, move down [count] times.

=item B<k>

Move up.  Used for scrolling through drop-down menus.  When prefixed
with a number, move up [count] times.

=item B<h>

Move to the left.  When in a nested drop-down menu, move into the
parent drop-down menu.  When prefixed with a number, move left [count]
times.

=item B<l>

Move to the right.  When on a folder, descend into that folder.  When
prefixed with a number, move right [count] times.

=item B<gg>

Move to the top of a drop-down menu.

Noting that the bookmark bar lays out bookmarks horizontally instead of the
vertical arrangement seen in drop down menus, these aliases will feel more
natural to Vim users on the bookmark bar.

=over

=item S< >^

Move to the beginning of the bookmark bar.

=item S< >0

Move to the beginning of the bookmark bar, provided that a count is not pending.

=back

There is no actual distinction in functionality; all three can be used
interchangeably.

=item B<G>

Move to the bottom of a drop-down menu.

Again noting that the bookmark bar lays out bookmarks horizontally instead of
the vertical arrangement seen in drop down menus, this alias will feel more
natural to Vim users on the bookmark bar.

=over

=item $ Move to the end of the bookmark bar.

=back

There is no actual distinction in functionality; G and $ can be used
interchangeably.

=item B<f{char}>

Jump to the next entry in the drop-down menu whose name begins with {char}.
When prefixed with a number, jump to the [count]th occurrence after the current
selection.  Does not work on the bookmark bar.

=item B<;>

Repeat the find command B<f{char}> with its most recent character.

=item B<x>

Cut the selected bookmark or folder.

=item B<y>

Yank the selected bookmark or folder.  Yank means to copy.

=item B<p>

Put a bookmark or folder.  Put means to paste.

=item B<dd>

Delete the selected bookmark or folder.  The double key press is a safeguard, so
you don't unintentionally delete a bookmark.

=item B<m>

Open the context menu on the selected bookmark or folder.

=item B<e>

Edit the currently selected bookmark or folder.

 edit bookmark dialog             edit folder dialog
 +----------------------------+   +----------------------------+
 | Edit bookmark              |   | Edit folder name           |
 |                            |   |                            |
 | Name _____________________ |   | Name _____________________ |
 | URL  _____________________ |   |                            |
 |                            |   |               Save  Cancel |
 | +------------------------+ |   +----------------------------+
 | |                        | |
 | |  Bookmarks bar         | |
 | |  |-- Personal          | |
 | |  |   `-- Recipes       | |
 | |  `-- Work              | |
 | |                        | |
 | +------------------------+ |
 |                            |
 | New Folder    Save  Cancel |
 +----------------------------+

Note that this is currently not supported.  I had this working, but it caused
some other problems, so I am temporarily removing this feature until I can come
up with a better implementation.

=item B<*>

Leave bookmarking mode and open the bookmark manager.  If your web browser
supports it, the bookmark manager will be opened to the currently selected
bookmark or folder.

Think of this as a fallback.  What cannot be done in bookmarking mode can be
done in the bookmark manager with the mouse.

=item B<Caps Lock>

Escape / Cancel.  If there is a pending count, cancel that; otherwise,
escape out of all drop-down menus.

I've already taken the liberty to remap Caps Lock to escape for you.
In the Vim community, it is a common practice to remap the Caps Lock
key to the escape key and vice versa.  This is because

=over

=item 1)

the escape key is used more frequently than the Caps Lock key,

=item 2)

but the Caps Locks key is in a more accessible position,

=item 3)

not to mention that the Caps Lock key is rendered obsolete by Vim's
many, more ergonomic operators for manipulating letter case, e.g.,
C<~>, C<gu>, and C<gU>.

=back

As noted before, these changes only take effect in bookmarking mode.  The Caps
Lock Key behaves normally in standard mode.  Unlike in Vim, the Escape (Caps
Lock) key does not exit a mode.

=back

=head2 Standard Mode

The following keyboard shortcuts can be used during standard mode.  They
automate some common tasks that would otherwise take several mouse clicks.  Some
of the keybindings perform complex UI operations, so it is best to just sit back
and let the computer "take the wheel" until execution finishes.  Currently these
only work with Chrome.

=over

=item B<CTRL+]>

Export your bookmarks to an HTML file.

Could fail if the window is not maximized.

=item B<CTRL+[>

Import your bookmarks from an HTML file.

Could fail if the window is not maximized.

=item B<ALT+]>

Remove the bookmark from the current page.

=item B<ALT+[>

Add or edit a bookmark.  When no bookmark exists for the current page, add one;
otherwise, edit the existing bookmark.  This will open Chrome's "Edit bookmark"
dialog.

=item B<CTRL+\>

Create a new user profile in Google Chrome.  A popup box will appear asking for
a username.  If you press "OK" without entering any text, a default name will be
used.

=item B<F1>

A hotkey to apply a bookmarklet over multiple tabs.  Put the bookmarklet that
you want to run in the far left position of your bookmark bar.  Call this
command and enter a number, say N.  The bookmarklet will be applied to the next
N tabs.  This works well with simple bookmarklets that alter the state of a
webpage.

Bookmarklets that

=over

=item * have pop-ups

=item * open new tabs

=item * take too long

=back

won't work.

=back

=head1 COMPATIBILITY

Some keybindings are not supported on all web browsers.  Firefox and Opera don't
have great support.  I might work on this later.

 +--------+--------+------+---------+-------+
 | Cmds   | Chrome | Edge | Firefox | Opera |
 +--------+--------+------+---------+-------+
 | gg ^ 0 | yes    | yes  | kinda   | yes   |
 | G $    | yes    | yes  | kinda   | yes   |
 | x      | yes    | yes  | yes     | no    |
 | y      | yes    | yes  | yes     | no    |
 | p      | yes    | yes  | kinda   | no    |
 | dd     | yes    | yes  | yes     | yes   |
 | *      | yes    | yes  | no      | yes   |
 +--------+--------+------+---------+-------+

Regarding Firefox:

=over

=item

You can paste with C<m2fp{Enter}> when over a bookmark and with C<mfp> when over
a folder.

=item

The bookmark bar is "locked down" comparative to other browsers.

=over

=item

On other browsers, you can use the down arrow (j) on a folder on the bookmark
bar to spawn a drop-down menu.  On Firefox however, you have to initially use
the enter key.

=item

The beginning and end commands (gg ^ 0 G $) do not work on the bookmark bar, but
they will work in drop-down menus.

=back

=back

=head1 CAVEATS

There are several points to bear in mind.

=over

=item

Web browsers are responsive, meaning that their UI components may change or move
around as the application is resized.  Bear in mind that this can disrupt the
functionality of this script.  Some hotkeys may fail to work if the application
window is sized down.  To achieve the intended functionality, your best bet is
to maximize the window when invoking a hotkey.

=item

The positioning of the mouse can distrust focus and consequently cause the
script to function improperly.  Make sure the mouse is not near the bookmark bar
or any pop-up menus when using a keybinding.  In bookmarking mode, the mouse is
outright disabled and even moved out of the way.  (Don't worry, its position is
later restored.)

=item

Web browsers is constantly changing.  New features are introduced all the time.
Context menus sometimes change, and UI components move around.  This requires me
to periodically update this script to adapt to a change.  Make sure you are
using the most up-to-date version of your browser.  I use this script daily, so
I am likely to stay on top of changes.

=item

I have personally verified this script to work with I<fresh installations> of
supported web browsers.  If you customize your web browser, e.g., by adding,
removing, or rearranging toolbar buttons, then you may introduce some breaking
change.

=back

=head1 BUGS

The C<e> command automatically leaves bookmarking mode so that the user can type
normally to make edits.  The problem is that after returning to standard mode,
the bookmark bar is left visible, which throws the hide/show cycle out of sync.
The user must follow up with C<CTRL+SHIFT+B> in order to resync it.  Without
losing the context menu, there is no opportunity to programmatically hide the
bar in between selecting edit from the context menu and receiving the edit
dialog box.

=head1 TODO

=over

=item *

Source code comments.

=item *

Support more web browsers.

=item *

Find an AutoHotkey style guide and adhere to it.

=item *

The mouse can do cool things too.  Document this.

=item *

Document how to make the script run at startup.

=item *

Reimplement this script in a language that runs on Linux, possibly AutoKey.
Maintain both versions.  See here: L<https://github.com/autokey/autokey>

=back

=head1 NOTES

You can compile this script so that the resulting executable has an icon by
using the following command.

	ahk2exe.exe /in bookmark-motions.ahk /out bookmark-motions.exe /icon bookmarks.ico

You can acquire a suitable icon using this bash script.

	1  #!/bin/bash
	2
	3  head=https://raw.githubusercontent.com/microsoft/fluentui-system-icons
	4  tail=/main/assets/Bookmark/SVG/ic_fluent_bookmark_32_filled.svg
	5  url=$head$tail
	6
	7  wget -q -O bookmarks.svg $url
	8  convert -background none bookmarks.svg bookmarks.ico
	9  rm bookmarks.svg

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=head1 HISTORY

=over

=item Wednesday, March 19th, 2025

=over

=item start a change log

=item implement [count] for C<h>, C<j>, C<k>, C<l>, and C<f>

=back

=item Thursday, March 20th, 2025

=over

=item  implement the edit command

=back

=item Friday, March 21st, 2025

=over

=item add username dialog to command for creating new chrome user

=item update to reflect change in chrome context menu

=back

=item Saturday, April 5th, 2025

=over

=item refactor code for importing and exporting bookmarks

=item modularize into functions

=item eliminate magic numbers

=item document caveats

=item disable C<A_MaxHotkeysPerInterval> warning dialog

=back

=item Friday, April 11th, 2025

=over

=item rename file to elucidate purpose

=item rebranding to emphasize Vim motions

=back

=item Monday, April 14th, 2025

=over

=item support other web browsers besides my own

=item overhaul implementation, refactor entirely

=back

=back

=cut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _                               _
; /  _ .__|_ _  _|_ |\/| _ ._     | \o _. _ .__.._ _  _
; \_(_)| ||_(/_><|_ |  |(/_| ||_| |_/|(_|(_||(_|| | |_>
;                                         _|

It is difficult to programmatically select items in context menus because the
context menus can vary depending on context. To complicate matters,  context
menus differ across browsers, requiring us to employ different methods on a
case-by-case basis.

There are common operations that can be performed on both bookmarks and folders,
like cut, copy, and paste.  If we can predictably access the menu items for
these common operations, then there is no trouble.  But if a common operation
has to be accessed in differing ways depending on weather the context menu is
for a bookmark or for a folder, then we have to be aware of that context, which
is difficult to do programmatically.  To help work out all of the oddities and
quirks, I have charted out the context menus in various browsers.

  ___ _
 / __| |_  _ _ ___ _ __  ___
| (__| ' \| '_/ _ \ '  \/ -_)
 \___|_||_|_| \___/_|_|_\___|

A) Context menu for bookmarks

B) Context menu for folders

+-------------------------------------------------------------------------+
|                                                                         |
|   EXHIBIT A                      EXHIBIT B                              |
|                                                                         |
|                                  .----------------------------------.   |
|   .--------------------------.   | Open all (n)                     |   |
|   | Open in new tab          |   | Open all (n) in new window       |   |
|   | Open in new window       |   | Open all (n) in Incognito window |   |
|   | Open in Incognito window |   | Open all (n) in new tab group    |   |
|   |--------------------------|   |----------------------------------|   |
|   | Edit...                  |   | Rename...                        |   |
|   |--------------------------|   |----------------------------------|   |
|   | Cut                      |   | Cut                              |   |
|   | Copy                     |   | Copy                             |   |
|   | Paste                    |   | Paste                            |   |
|   |--------------------------|   |----------------------------------|   |
|   | Delete                   |   | Delete                           |   |
|   |--------------------------|   |----------------------------------|   |
|   | Add page...              |   | Add page...                      |   |
|   | Add folder...            |   | Add folder...                    |   |
|   |--------------------------|   |----------------------------------|   |
|   | Bookmark manager         |   | Bookmark manager                 |   |
|   | Show apps shortcut  [ ]  |   | Show apps shortcut  [ ]          |   |
|   | Show tab groups     [ ]  |   | Show tab groups     [ ]          |   |
|   | Show bookmarks bar  [ ]  |   | Show bookmarks bar  [ ]          |   |
|   .--------------------------.   .----------------------------------.   |
|                                                                         |
+-------------------------------------------------------------------------+

 ___    _
| __|__| |__ _ ___
| _|/ _` / _` / -_)
|___\__,_\__, \___|
         |___/

A) Context menu for bookmarks

B) Context menu for folders

+---------------------------------------------------------------------------------------------+
|                                                                                             |
|   EXHIBIT A                                    EXHIBIT B                                    |
|                                                                                             |
|   .--------------------------------------.     .--------------------------------------.     |
|   | # Open in new tab                    | o   | # Open all (n)                       | o   |
|   | # Open in new window                 | n   | # Open all (n) in new window         | n   |
|   | # Open in InPrivate window           | i   | # Open all (n) in InPrivate window   | i   |
|   |--------------------------------------|     |   Open all (n) in new tab group      | n   |
|   | # Edit                               | e   |--------------------------------------|     |
|   |   Show icon only                     | h   |   Rename                             | r   |
|   |--------------------------------------|     |--------------------------------------|     |
|   | # Cut                                | t   | # Cut                                | t   |
|   | # Copy                               | c   | # Copy                               | c   |
|   | # Paste                              | p   | # Paste                              | p   |
|   |--------------------------------------|     |--------------------------------------|     |
|   | # Delete                             | d   | # Delete                             | d   |
|   |--------------------------------------|     |--------------------------------------|     |
|   | # Add this page to favorites  Ctrl+D | a   | # Add this page to favorites  Ctrl+D | a   |
|   | # Add folder                         | f   | # Add folder                         | f   |
|   |--------------------------------------|     |--------------------------------------|     |
|   |   Show favorites bar  Ctrl+Shift+B > | s   |   Show favorites bar  Ctrl+Shift+B > | s   |
|   |   Hide favorites button from toolbar | b   |   Hide favorites button from toolbar | b   |
|   | # Manage favorites                   | m   | # Manage favorites                   | m   |
|   .--------------------------------------.     .--------------------------------------.     |
|                                                                                             |
+---------------------------------------------------------------------------------------------+

 ___ _          __
| __(_)_ _ ___ / _|_____ __
| _|| | '_/ -_)  _/ _ \ \ /
|_| |_|_| \___|_| \___/_\_\

A) Context menu for bookmarks appearing on the bookmark bar

B) Context menu for folders appearing on the bookmark bar

C) Context menu for bookmarks that are within subfolders
   of folders appearing on the bookmark bar

D) Context menu for folders that are subfolders of folders
   appearing on the bookmark bar

+-----------------------------------------------------------------------+
|                                                                       |
|    EXHIBIT A                         EXHIBIT B                        |
|                                                                       |
|   .----------------------------.                                      |
|   | Open in New Tab            | w   .--------------------------.     |
|   | Open in New Window         | n   | Open All Bookmarks       | o   |
|   | Open in New Private Window | p   | -------------------------|     |
|   | ---------------------------|     | Edit Folder...           | e   |
|   | Edit Bookmark...           | e   | Delete Folder            | d   |
|   | Delete Bookmark            | d   | Sort By Name             | r   |
|   |----------------------------|     |--------------------------|     |
|   | Cut                        | t   | Cut                      | t   |
|   | Copy                       | c   | Copy                     | c   |
|   | Paste                      | p   | Paste                    | p   |
|   |----------------------------|     |--------------------------|     |
|   | Add Bookmark...            | b   | Add Bookmark...          | b   |
|   | Add Folder...              | f   | Add Folder...            | f   |
|   | Add Separator              | s   | Add Separator            | s   |
|   |----------------------------|     |--------------------------|     |
|   | Bookmark Toolbar >         | b   | Bookmark Toolbar >       | b   |
|   | Show Other Bookmarks [ ]   | h   | Show Other Bookmarks [ ] | h   |
|   | Manage Bookmarks           | m   | Manage Bookmarks         | m   |
|   .----------------------------.     .--------------------------.     |
|                                                                       |
|    EXHIBIT C                         EXHIBIT D                        |
|                                                                       |
|   .----------------------------.                                      |
|   | Open in New Tab            | w   .--------------------.           |
|   | Open in New Window         | n   | Open All Bookmarks | o         |
|   | Open in New Private Window | p   | -------------------|           |
|   | ---------------------------|     | Edit Folder...     | e         |
|   | Edit Bookmark...           | e   | Delete Folder      | d         |
|   | Delete Bookmark            | d   | Sort By Name       | r         |
|   |----------------------------|     |--------------------|           |
|   | Cut                        | t   | Cut                | t         |
|   | Copy                       | c   | Copy               | c         |
|   | Paste                      | p   | Paste              | p         |
|   |----------------------------|     |--------------------|           |
|   | Add Bookmark...            | b   | Add Bookmark...    | b         |
|   | Add Folder...              | f   | Add Folder...      | f         |
|   | Add Separator              | s   | Add Separator      | s         |
|   |----------------------------|     |--------------------|           |
|   | Bookmark Toolbar >         | b   | Bookmark Toolbar > | b         |
|   | Manage Bookmarks           | m   | Manage Bookmarks   | m         |
|   .----------------------------.     .--------------------.           |
|                                                                       |
+-----------------------------------------------------------------------+

  ___
 / _ \ _ __  ___ _ _ __ _
| (_) | '_ \/ -_) '_/ _` |
 \___/| .__/\___|_| \__,_|
      |_|

A) Context menu for bookmarks

B) Context menu for folders

*) The workspace item won't appear when there is only one workspace.

+-------------------------------------------------------------------------+
|                                                                         |
|   EXHIBIT A                        EXHIBIT B                            |
|                                                                         |
|                                    .--------------------------------.   |
|                                    | Open all                       |   |
|   .----------------------------.   | Open all in new window         |   |
|   | Open                       |   | Open all in new private window |   |
|   | Open in new tab            |   | Open all in workspace >        |   |
|   | Open in new window         |   | -------------------------------|   |
|   | Open in new private window |   | Rename...                      |   |
|   | Open in workspace >        |   | Move to Trash                  |   |
|   |----------------------------|   | -------------------------------|   |
|   | Edit...                    |   | Add site...                    |   |
|   | Move to Trash              |   | Add folder...                  |   |
|   |----------------------------|   | -------------------------------|   |
|   | Bookmarks...               |   | Bookmarks...                   |   |
|   | Hide bookmarks bar         |   | Hide bookmarks bar             |   |
|   .----------------------------.   .--------------------------------.   |
|                                                                         |
+-------------------------------------------------------------------------+

*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; / | _. _ _ _  _
; \_|(_|_>_>(/__>

class Mouse {

	static Save() {

		MouseGetPos(&x, &y)
		this.x := x
		this.y := y
	}

	static Hide() {

		this.Save()
		MouseMove(0, 0)            ; move mouse out of way
		BlockInput("MouseMove")    ; disable mouse movement
	}

	static Show() {

		MouseMove(this.x, this.y)  ; restore mouse position
		BlockInput("MouseMoveOff") ; re-enable mouse movement
	}
}

class Browser {

	static UNKNOWN := 0
	static CHROME  := 1
	static EDGE    := 2
	static FIREFOX := 3
	static OPERA   := 4

	static EXECUTABLES := Map(
		this.CHROME,  "chrome",
		this.EDGE,    "msedge",
		this.FIREFOX, "firefox",
		this.OPERA,   "opera"
	)

	static Identity() {

		For Id, Executable in this.EXECUTABLES {

			If WinActive("ahk_exe " Executable ".exe") {

				return Id
			}
		}
		return this.UNKNOWN
	}

	static IsActive() {

		return !!this.Identity()
	}
}

class BookmarkBar {

	static Toggle() {

		Switch Browser.Identity() {

			Case Browser.CHROME, Browser.EDGE, Browser.FIREFOX:

				Send("^+b")

			Case Browser.OPERA:

				Send("{Esc}")
				Send("{F10}")
				Send("{Enter}")
				Send("b")
				Send("s")
		}
	}

	static Focus() {

		Switch Browser.Identity() {

			Case Browser.CHROME, Browser.EDGE:

				Send("!+b")

			Case Browser.FIREFOX:

				delay := 100

				Send("{Esc 2}")     , Sleep(delay)
				Send("^l")          , Sleep(delay)
				Send("{Backspace}") , Sleep(delay)
				Send("{Tab 2}")

			Case Browser.OPERA:

				Send("{F10}{F6 3}")
		}
	}
}

; Ideally, this should be a page reload monitor, not a
; tab change monitor.  If the same page is reloaded, the
; desired effect will not be realized.  The problem is
; that I'm not sure how to detect page reloads with
; AutoHotkey.

class TabChangeMoniter {

	static timeout := 1000 ; milliseconds

	static previousTab := ""
	static currentTab  := ""

	static Execute(functionReference) {

		this.previousTab := WinGetTitle("A")

		functionReference.Call()

		SetTimer ObjBindMethod(this, "FollowUp"), -this.timeout
	}

	static FollowUp() {

		this.currentTab := WinGetTitle("A")

		If (this.currentTab != this.previousTab) {

			; TODO abstract this with a user-supplied callback

			BookmarkBar.Focus() ; <----

			this.previousTab := this.currentTab
		}
	}
}

class BookmarkingMode {

	static status      := false
	static enterVolume := 1500
	static exitVolume  := 1000

	static IsEnabled() {

		return this.status
	}

	static Toggle() {

		this.status ^= 1
	}

	static Enter() {

		SoundBeep(this.enterVolume)
		Mouse.Hide(), Sleep(100)
		BookmarkBar.Toggle(), Sleep(100)
		BookmarkBar.Focus()
	}

	static Exit() {

		SoundBeep(this.exitVolume)
		EscapeAllDropDownMenus(), Sleep(100)
		BookmarkBar.Toggle(), Sleep(100)
		FocusWebPage(), Sleep(100)
		Mouse.Show()
	}

	static PermitsHotkeys() {

		return (
			 this.IsEnabled() &&
			 Browser.IsActive() &&
			!OperatorPendingMode.IsEnabled()
		)
	}

	static Monitor() {

		toggleFlag := 0

		Loop {
			If this.IsEnabled() {
				If !toggleFlag { ; then entering mode
					toggleFlag := 1
					this.Enter()
				} ; otherwise the mode is already enabled
			} Else {
				If toggleFlag { ; then exiting mode
					toggleFlag := 0
					this.Exit()
				} ; otherwise the mode is already disabled
			}
			Sleep(25)
		}
	}
}

class OperatorPendingMode {

	static status := false

	static IsEnabled() {

		return this.status
	}

	static Enter() {

		this.status := true
	}

	static Exit() {

		this.status := false
	}
}

class Counter {

	static count := 0

	static Get() {

		return this.count || 1
	}

	static Reset() {

		this.count := 0
	}

	static Update(new_digit) {

		existing_digits := this.count

		this.count := 10 * existing_digits + new_digit
	}

	static IsPending() {

		return this.count != 0
	}
}

class Locator {

	static latestKey := ""

	static Locate() {

		OperatorPendingMode.Enter()

		this.latestKey := GetNextKeyPress()

		Loop Counter.Get() {

			SendText(this.latestKey)
		}

		Counter.Reset()

		OperatorPendingMode.Exit()
	}

	static Repeat() {

		If !this.latestKey
			return

		OperatorPendingMode.Enter()
		SendText(this.latestKey)
		OperatorPendingMode.Exit()
	}
}

class ContextMenuSelector {

	static delay := 500

	static SelectByNumber(number, direction := true) {

		Send("{AppsKey}")
		Sleep(this.delay)
		Send("{" (direction ? "Down" : "Up") " " number "}")
		Sleep(this.delay)
		Send("{Enter}")
	}

	static SelectByLetter(letter, count := 1) {

		OperatorPendingMode.Enter()

		Send("{AppsKey}")

		Sleep(this.delay)

		Loop count
			SendText(letter)

		If count > 1
			Send("{Enter}")

		OperatorPendingMode.Exit()
	}
}

class Motions { ; and operators too. I'll worry about semantics later.

	static Move(direction) {

		Send("{" direction " " Counter.Get() "}")

		Counter.Reset()
	}

	static GotoBeginning() {

		Send("{Home}")
	}

	static GotoEnd() {

		Send("{End}")
	}

	static Find() {

		TabChangeMoniter.Execute(() => Locator.Locate())
	}

	static FindAgain() {

		Locator.Repeat()
	}

	static Escape() {

		If (Counter.isPending())
			Counter.Reset()
		Else
			EscapeAllDropDownMenus()
	}

	static Confirm() {

		TabChangeMoniter.Execute(() => Send("{Enter}"))
	}

	static Cut() {

		Switch Browser.Identity() {

			Case Browser.CHROME:

				ContextMenuSelector.SelectByNumber(10, false)

			Case Browser.EDGE:

				ContextMenuSelector.SelectByNumber(5)

			Case Browser.FIREFOX:

				ContextMenuSelector.SelectByLetter("t")

			Case Browser.OPERA:

				; Sadly, the standard cut, copy, and paste items
				; do not appear in Opera's bookmark bar context
				; menus.  Not sure what to do here.
		}
	}

	static Yank() {

		Switch Browser.Identity() {

			Case Browser.CHROME:

				ContextMenuSelector.SelectByNumber(9, false)

			Case Browser.EDGE:

				ContextMenuSelector.SelectByNumber(6)

			Case Browser.FIREFOX:

				ContextMenuSelector.SelectByLetter("c")

			Case Browser.OPERA:

				; ditto
		}
	}

	static Put() {

		Switch Browser.Identity() {

			Case Browser.CHROME:

				ContextMenuSelector.SelectByNumber(8, false)

			Case Browser.EDGE:

				ContextMenuSelector.SelectByNumber(7)

			Case Browser.FIREFOX:

			; TODO requires context awareness

			; PSEUDO CODE
			; If Context = Bookmark
			;     ContextMenuSelector.SelectByLetter('p', 1)
			; Else If Context = Folder
			;     ContextMenuSelector.SelectByLetter('p', 2)

			Case Browser.OPERA:

				; ditto
		}
	}

	static Delete() {

		Switch Browser.Identity() {

			Case Browser.CHROME:

				ContextMenuSelector.SelectByNumber(7, false)

			Case Browser.EDGE:

				ContextMenuSelector.SelectByNumber(8)

			Case Browser.FIREFOX:

				ContextMenuSelector.SelectByLetter("d")

				BookmarkBar.Focus()

			Case Browser.OPERA:

				ContextMenuSelector.SelectByLetter("m")
		}
	}

	static OpenBookmarkManager() {

		Switch Browser.Identity() {

			Case Browser.CHROME:

				ContextMenuSelector.SelectByNumber(4, false)

				BookmarkingMode.Toggle()

			Case Browser.EDGE:

				ContextMenuSelector.SelectByNumber(1, false)

				BookmarkingMode.Toggle()

			Case Browser.FIREFOX:

				; I need to think about this.  The bookmark
				; manager opens in its own window.  Because
				; focus is redirected to the new window, we
				; cannot exit bookmarking mode.

			Case Browser.OPERA:

				ContextMenuSelector.SelectByNumber(2, false)

				BookmarkingMode.Toggle()
		}
	}
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; |_  ._  __|_o _ ._  _
; ||_|| |(_ |_|(_)| |_>

DoubleKeyPress() {

	If !A_PriorHotkey
		return false

	timeout_duration := 300 ; milliseconds
	pressed_twice    := A_ThisHotkey = A_PriorHotkey
	pressed_quickly  := A_TimeSincePriorHotkey < timeout_duration

	return pressed_twice && pressed_quickly
}

; Accept a single keypress from the user

; Credit for this function goes to a post on the AutoHotkey forums.
; https://www.autohotkey.com/boards/viewtopic.php?t=122234#p542806

GetNextKeyPress() {


	hook := InputHook("L1") ; L1 denotes a string of length 1

	hook.Start()
	hook.Wait()

	return hook.Input
}

FocusWebPage() {

	Switch Browser.Identity() {

		Case Browser.CHROME, Browser.EDGE:

			Send("^{F6}")

		Case Browser.FIREFOX:

			Send("{F6}")

		Case Browser.OPERA:

			Send("{F9}")
	}
}

EscapeAllDropDownMenus() {

	/* I couldn't find documentation on this anywhere, but I've discovered
	 * that pressing the alt key--not as a modifier but by itself--will
	 * escape out of all drop-down menus in some web broswers.
	 */

	Send("{Alt}")

	If Browser.Identity() = Browser.FIREFOX

		Send("{Esc}")
}

Main() {
	BookmarkingMode.Monitor()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; |_| __|_|  _    _
; | |(_)|_|<(/_\/_>
;              /

#HotIf Browser.IsActive()

\::{
	If !DoubleKeyPress() {

		SendText("\")
		return
	}
	BookmarkingMode.Toggle()
}

#HotIf

#HotIf BookmarkingMode.PermitsHotkeys()

 a::return
+a::return
 b::return
+b::return
 c::return
+c::return
 d::{
 	If DoubleKeyPress()
 		Motions.Delete()
 }
+d::return
 e::return
+e::return
 f::Motions.Find()
+f::return
 g::{
 	If DoubleKeyPress()
 		Motions.GotoBeginning()
 }
+g::Motions.GotoEnd()
 h::Motions.Move("Left")
+h::return
 i::return
+i::return
 j::Motions.Move("Down")
+j::return
 k::Motions.Move("Up")
+k::return
 l::Motions.Move("Right")
+l::return
 m::AppsKey
+m::return
 n::return
+n::return
 o::return
+o::return
 p::Motions.Put()
+p::return
 q::return
+q::return
 r::return
+r::return
 s::return
+s::return
 t::return
+t::return
 u::return
+u::return
 v::return
+v::return
 w::return
+w::return
 x::Motions.Cut()
+x::return
 y::Motions.Yank()
+y::return
 z::return
+z::return

1::Counter.Update(1)
2::Counter.Update(2)
3::Counter.Update(3)
4::Counter.Update(4)
5::Counter.Update(5)
6::Counter.Update(6)
7::Counter.Update(7)
8::Counter.Update(8)
9::Counter.Update(9)
0::{
	If Counter.IsPending()
		Counter.Update(0)
	Else
		Motions.GotoBeginning()
}

CapsLock::Motions.Escape()
Enter::Motions.Confirm()

$::Motions.GotoEnd()
*::Motions.OpenBookmarkManager()
^::Motions.GotoBeginning()
`;::Motions.FindAgain()

#HotIf

Main() ; kick everything off

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; |\/|o _ _ _ || _.._  _  _     _
; |  ||_>(_(/_||(_|| |(/_(_)|_|_>

; The remaining code is Chrome specfic and needs refactored.

#HotIf WinActive("ahk_exe chrome.exe") && !BookmarkingMode.IsEnabled()

; IMPORT/EXPORT BOOKMAKRS

;	^t        new tab
;	^+o       bookmark manager
;	{Tab}     focus on kebab menu (three vertical dots)
;	{Enter}   select it
;       {Up num}  navigate to menu option
;	...         num is either 2 or 3
;	...           2 = export bookmarks
;	...           3 = import bookmarks
;	{Enter}   select it
;	...       enter name of file
;	{Enter}   confirm
;	^w        close tab (bookmark manager)

Portation(num, file) {

	if !file
		return

	delay := 750

	Send("^t"),           Sleep(delay)
	Send("^+o"),          Sleep(delay)
	Send("{Tab}"),        Sleep(delay)
	Send("{Enter}"),      Sleep(delay)
	Send("{Up " num "}"), Sleep(delay)
	Send("{Enter}"),      Sleep(delay)
	SendText(file),       Sleep(delay * 1.5)
	Send("{Enter}"),      Sleep(delay)
	Send("^w")

} ; https://english.stackexchange.com/q/141717

SelectImportFile() {

	FileMustExist := 1
	PathMustExist := 2
	Options := FileMustExist + PathMustExist

	return FileSelect(Options,, "Bookmark Importer", "*.html")
}

SelectExportFile() {

	return FileSelect("S",, "Bookmark Exporter", "*.html")
}

ImportBookmarks() {

	NumberOfUpsToReachImportMenuItem := 3

	Portation(NumberOfUpsToReachImportMenuItem, SelectImportFile())
}

ExportBookmarks() {

	NumberOfUpsToReachExportMenuItem := 2

	Portation(NumberOfUpsToReachExportMenuItem, SelectExportFile())
}

^[::ImportBookmarks()
^]::ExportBookmarks()

; CREATE A NEW USER PROFILE IN GOOGLE CHROME

;	{F10}     set focus on the rightmost item in the chrome toolbar
;	{Left}    ...
;	{Enter}   profile
;	{Up 3}    ...
;	{Enter}   add chrome profile
;	{Tab 2}   ...
;	{Enter}   continue without an account
;	...       add a name or label, like work or personal
;	{Tab 2}   ...
;	{Enter}   done
;	^t        new tab -> enhanced ad privacy in chrome
;	{Tab 3}   ...
;	{Enter}   got it
;	^w        close tab

NewChromeUser() {

	IB := InputBox("Please enter a username.", "Username", "w300 h100")

	If IB.Result = "Cancel"
		return

	username := IB.value || "Secondary"

	delay := 750

	Send("{F10}"),      Sleep(delay)
	Send("{Left}"),     Sleep(delay)
	Send("{Enter}"),    Sleep(delay)
	Send("{Up 3}"),     Sleep(delay)
	Send("{Enter}"),    Sleep(delay)
	Send("{Tab 2}"),    Sleep(delay)
	Send("{Enter}"),    Sleep(delay)
	SendText(username), Sleep(delay)
	Send("{Tab 2}"),    Sleep(delay)
	Send("{Enter}"),    Sleep(delay)
	Send("^t"),         Sleep(delay)
	Send("{Tab 3}"),    Sleep(delay)
	Send("{Enter}"),    Sleep(delay)
	Send("^w"),         Sleep(delay)

} ; Thursday, June 6th, 2024

^\::NewChromeUser()

; APPLY BOOKMARKLET OVER MULTIPLE TABS.

F1::
{
	num := InputBox("Enter a number.").value

	Loop num {

		Send("!+b{Enter}^{Tab}")
		Sleep(500)

	}

} ; Monday, April 29th, 2024

; ADD OR EDIT A BOOKMARK

![::
{
	MouseMove(0, 0) ; the script fails if the mouse disrupts focus
	Send("{Ctrl down}d{Ctrl up}{Tab}{Enter}{Up}{Enter}")
	return
}

; DELETE A BOOKMARK

!]::
{
	MouseMove(0, 0)
	Send("{Ctrl down}d{Ctrl up}{Tab}{Tab}{Tab}{Enter}")
	return
}

; MOUSE RELATED STUFF

context_menu := 0

; The left and right mouse buttons are
; repurposed for interacting with
; bookmarks and their context menus.

LButton::
{

	; The left-hand mouse button sends the
	; enter key.  Use it to open a bookmark
	; or to select an item in a context menu.

	global context_menu := 0 ; closes after pressing enter

	Send("{Enter}")

	; refocus on the bookmark bar for continued navigation

	Send("!+b")

} ; Hotkey

RButton::
{

	; The right-hand mouse button accesses
	; the context menu of the currently
	; selected bookmark.  If pressed again,
	; it escapes out of that menu.

	global context_menu := !context_menu

	Send(context_menu ? "{AppsKey}" : "{Esc}")

} ; Hotkey

; The mouse's scroll wheel and extra
; side buttons are repurposed to
; function as arrow keys for easy menu
; navigation.

WheelUp::   Send("{up}")
WheelDown:: Send("{down}")
XButton1::  Send("{right}")
XButton2::  Send("{left}")

; When holding shift, reverse up and
; down with left and right for
; horizontal scrolling.

+WheelUp::   Send("{left}")
+WheelDown:: Send("{right}")
+XButton1::  Send("{up}")
+XButton2::  Send("{down}")

#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
