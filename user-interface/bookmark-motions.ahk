;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FILENAME: bookmark-motions.ahk
; AUTHOR: Zachary Krepelka
; DATE: Friday, March 8th, 2024
; ABOUT: Vim motions for bookmark management
; ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
; UPDATED: Monday, June 2nd, 2025 at 3:27 AM

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

Conversely, this script also enables the opposite paradigm.  The mouse is
endowed with advanced modal functionality, making it possible to manage one's
bookmarks using only a mouse.

The supported web browsers are listed below.

=over

=item

Google Chrome

=item

Microsoft Edge

=item

Mozilla Firefox

=item

Opera & Opera GX

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
audible beep will sound to indicate that the key press was registered.  You can
also do this with the mouse by pressing both side buttons at the same time.

While in bookmarking mode, the bookmark bar is visible.  Otherwise, it is
hidden.  This keeps your workspace looking clean and uncluttered.  Maximize
screen real estate, reduce digital overload.

=head1 KEYBINDINGS

=head2 Bookmarking Mode

The following keyboard shortcuts are available when bookmarking mode is active.
These keybindings are largely Vim-inspired, meaning that you will use hjkl
instead of the arrow keys.

	  k
	h   l
	  j

Some keybindings are not supported on all web browsers.  Refer to the section
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

=head1 MOUSE ACTIONS

This script makes it possible to navigate the bookmark bar and the drop-down
menus off of it using only a mouse.  You can also access context menus on these
items, thereby enabling a full range of operations.  Here's how it works.

The mouse behaves normally in standard mode and is given new functionality in
bookmarking mode.  In bookmarking mode, the mouse cursor is locked down and
moved out of the way.  Instead of using the pointer, you will use the various
other input facilities on your mouse, such as

=over

=item

the left and right buttons

=item

the scroll wheel

=item

the two side buttons

=back

Before getting into the particulars, let's address some preliminary knowledge.
There are two environments that you will be working from when managing your
bookmarks.

=over

=item 1 The Bookmark Bar

Here bookmarks and folders are laid out horizontally across the top of the
screen.

=item 2 Drop-Down Menus off of the Bookmark Bar

Here bookmarks and folders are laid out vertically in possibly long lists which
work their way across the screen as further submenus are opened.

=back

These two environments are depicted in the following image.

 .--------------------------------------------------------------------.
 | # Shopping # Reading # Leisure # Social # Finance # Recipes # News |
 .------------|-------------------------------------------------------.
              |
              |--------------.
              | Fiction    >-|--------------.
              | Nonfiction   |  | Fantasy   |
              .--------------.  | Science   |
                                | Mystery   |
                                | Horror  >-|-------------------------.
                                | Romance   |  | The Jaunt            |
                                .-----------.  | The Black Cat        |
                                               | The Yellow Wallpaper |
                                               | Colour Out of Space  |
                                               .----------------------.

The following mouse actions take effect when bookmarking mode is active.

=over

=item * Middle Mouse Wheel Button

This button toggles the scrolling orientation of the mouse.  Essentially, it is
a way to move between the two aforementioned environments.

When the user first enters bookmarking mode, the first item on the bookmark bar
is focused.  The user can use the scroll wheel to move the focus ring to other
items on the bookmark bar.  Thereon, the mouse is initially in horizontal
scrolling mode.

With the focus ring over a folder on the bookmark bar, the user can press the
middle mouse button to switch to vertical scrolling mode, after which the user
can descend into that folder's drop-down menu.  This will actually anchor the
focus ring in place over the folder.  The focus element is now a rectangular bar
that moves up and down along the drop-down menu.  The user should avoid
anchoring on bookmarks.

The middle mouse button acts as a toggle.  If it is pressed again, this time
from within the drop-down menus, then focus will be returned to the bookmark bar
where horizontal scrolling is renewed.  All of the drop-down menus will
consequently close.

=item * Left Mouse Button

When in a nested drop-down menu, move into the parent drop-down menu.  That is,
move to the left.  Only applies during vertical scrolling.

=item * Right Mouse Button

When on a folder in a drop-down menu (or generally any sub-menu), descend into
that folder.  That is, move to the right.  Only applies during vertical
scrolling.

=item * First Side Button

Opens the context menu for the focused element.  If pressed again while the
context menu is still open, this will close the context menu as a means of
canceling.  This button functions as a toggle.

=item * Second Side Button

Select a bookmark or context menu item.  All of the drop-down menus will
subsequently close, and focus will be redirected back to the bookmark bar for
continued navigation.

The user should avoid using this button to descend into a folder, as it will
induce unwanted behavior.  Use the right mouse button instead.

=item * Both Side Buttons

Pressing both side buttons at the same time will
toggle bookmarking mode on and off.

=item * Mouse Wheel Up

Moves B<right> in horizontal scrolling mode, up otherwise.

=item * Mouse Wheel down

Moves B<left> in horizontal scrolling mode, down otherwise.

=back

=head1 COMPATIBILITY

Some keybindings are not supported on all web browsers.
Firefox and Opera don't have great support.
I might work on this later.

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
they will work in drop-down menus.  You can use C<33h> and C<33l> in lieu of
C<gg> and C<G>.  Thirty three is large enough to span the full length, and it is
convenient to type.

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

=head1 TODO

=over

=item *

Source code comments.

=item *

Support more web browsers.

=item *

Find an AutoHotkey style guide and adhere to it.

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

=item Tuesday, April 15th, 2025

=over

=item refactor, enhance, and document mouse functionality

=back

=back

=cut

*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; / | _. _ _ _  _
; \_|(_|_>_>(/__>

class Mouse {

	static horizontal_scroll  := true
	static context_menu       := false
	static pending_transition := false

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

	static ToggleScrollDirection() {

		; FIXME shouldn't be used when context menu is active

		EscapeAllDropDownMenus()

		this.horizontal_scroll ^= 1
	}

	static OnWheelUp() {

		Send(this.horizontal_scroll ? "{right}" : "{up}")
	}

	static OnWheelDown() {

		Send(this.horizontal_scroll ? "{left}" : "{down}")
	}

	static OnLeftClick() {

		If !this.horizontal_scroll
			Send("{left}")
	}

	static OnRightClick() {

		If !this.horizontal_scroll
			Send("{right}")
	}

	static ToggleContextMenu() {

		menu_opened_from_bar := (
			 this.horizontal_scroll &&
			!this.context_menu)

		menu_closed_from_bar := (
			!this.horizontal_scroll &&
			 this.context_menu &&
			 this.pending_transition)

		If menu_opened_from_bar {

			this.horizontal_scroll := false
			this.pending_transition := true
		}

		If menu_closed_from_bar {

			this.horizontal_scroll := true
			this.pending_transition := false
		}

		Send(this.context_menu ? "{Esc}" : "{AppsKey}")

		this.context_menu ^= 1
	}

	; DIFFICULT EDGE CASE

	; Regarding Mouse.Select() and associated logic:

	; When selecting items in context menus from within drop-down
	; lists, the browser will drop you back to the bookmark bar and
	; escape out of all those drop down menus once the selection has
	; been made.

	; An exception is the `delete` item, which leaves the drop-down
	; menus open.  This one-off case will throw the script out of
	; sync, since we work under the assumption that the drop-down
	; lists are in fact closed.  To the user, the mouse-driven
	; selector will appear to freeze in place.  A provisional
	; solution is to follow up with the button bound to
	; ToggleScrollDirection()

	static Select() {

		this.horizontal_scroll := true
		this.context_menu := false
		TabChangeMoniter.Execute(() => Send("{Enter}"))
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

	static Activate() {

		 ; assumes that the bookmark bar is hidden

		this.Toggle()

		Sleep(100)

		this.Focus()
	}

	static Deactivate() {

		 ; assumes that the bookmark bar is shown

		EscapeAllDropDownMenus()

		Sleep(100)

		this.Toggle()

		Sleep(100)

		FocusWebPage()
	}

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
		BookmarkBar.Activate()
	}

	static Exit() {

		SoundBeep(this.exitVolume)
		BookmarkBar.Deactivate()
		Mouse.Show()
	}

	static PermitsHotkeys() {

		return (
			 this.IsEnabled() &&
			 Browser.IsActive() &&
			!OperatorPendingMode.IsEnabled()
		)
	}

	static BypassUntil(Keys) {

		OperatorPendingMode.Enter()

		OnKeyDown(Hook, VirtualKey, ScanKey) {
			For CandidateKey in Keys {
				If CandidateKey = VirtualKey {
					Hook.Stop()
					OperatorPendingMode.Exit()
					return
				}
			}
		}

		Hook := InputHook("V")
		Hook.OnKeyDown := OnKeyDown
		Hook.KeyOpt("{All}", "+N")
		Hook.Start()
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

	static SAFETY_LIMIT := 100

	static Reset() {

		this.count := 0
	}

	static Guard() {

		If this.count > this.SAFETY_LIMIT

			this.Reset()
	}

	static Get() {

		this.Guard()

		return this.count || 1
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

	static Edit() {

		Switch Browser.Identity() {

			Case Browser.CHROME:

				ContextMenuSelector.SelectByNumber(11, false)

				BookmarkingMode.BypassUntil([0x0D, 0x1B])

			; TODO other browsers
		}
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

A_HotkeyInterval := 0

#HotIf Browser.IsActive()

\::{
	If DoubleKeyPress()
		BookmarkingMode.Toggle()
	Else
		SendText("\")
}

XButton1 & XButton2::BookmarkingMode.Toggle()

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
 e::Motions.Edit()
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

WheelUp::   Mouse.OnWheelUp()
WheelDown:: Mouse.OnWheelDown()
LButton::   Mouse.OnLeftClick()
RButton::   Mouse.OnRightClick()
MButton::   Mouse.ToggleScrollDirection() ; should only use in certain contexts
XButton1::  Mouse.ToggleContextMenu()
XButton2::  Mouse.Select()

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

#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
