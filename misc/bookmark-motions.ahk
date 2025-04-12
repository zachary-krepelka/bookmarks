;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FILENAME: bookmark-motions.ahk
; AUTHOR: Zachary Krepelka
; DATE: Friday, March 8th, 2024
; ABOUT: Vim motions for bookmark management
; ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
; UPDATED: Friday, April 11th, 2025 at 9:18 PM

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

=head2 Invocation

	start bookmark-motions.exe

=head2 Termination

	taskkill /IM bookmark-motions.exe

=head2 Compilation

	Ahk2Exe.exe /in bookmark-motions.ahk /out bookmark-motions.exe

	Using https://github.com/AutoHotkey/Ahk2Exe.git

=head1 DESCRIPTION

The purpose of this script is to provide an enhanced user interface method for
working with one's bookmarks in various web browsers.  This script aims to
provide a Vim-like, keyboard-centric experience for bookmark management,
allowing the user to manage their bookmarks without the use of a mouse.

Currently only Google Chrome is supported, but I am working on making it work
with other web browsers.  Because this script is written with AutoHotkey, it
will only run on Windows operating systems, but one day I intend to write a port
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

=item B<G>

Move to the bottom of a drop-down menu.

=item B<f{char}>

Jump to the next entry in the drop-down menu whose name begins with {char}.
When prefixed with a number, jump to the [count]th occurrence after the current
selection.

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

=item B<s>

Sort the currently selected folder by name.

=item B<*>

Open the selected bookmark or folder in the bookmark manager.
Then enter standard mode.

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

As noted before, these changes only take effect in bookmarking mode.
The Caps Lock Key behaves normally in standard mode.

=back

=head2 Standard Mode

The following keyboard shortcuts can be used during standard mode.  They
automate some common tasks that would otherwise take several mouse clicks.  Some
of the keybindings perform complex UI operations, so it is best to just sit back
and let the computer "take the wheel" until execution finishes.

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

=head1 CAVEATS

There are several points to bear in mind.

=over

=item

Google Chrome is responsive, meaning that its UI components may change or move
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

Google Chrome is constantly changing.  New features are introduced all the time.
Context menus sometimes change, and UI components move around.  This requires me
to periodically update this script to adapt to a change.  Make sure you are
using the most up-to-date version of Chrome.  I use this script daily, so I am
likely to stay on top of changes.

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

Disable the use of standard mode commands in bookmarking mode.  Using a standard
mode command in bookmarking mode will result in undefined behavior.

=item *

Support other web browsers.  Currently, only Google Chrome is supported.  Add
command-line flags to specify the target web browser, possibly like this:

=over

=item -c, --chrome (default)

=item -f, --firefox

=item -e, --edge

=back

=item *

Reimplement this script in a language that runs on Linux, possibly AutoKey.
Maintain both versions.

L<https://github.com/autokey/autokey>

=item *

The mouse can do cool things too.  Document this.

=item *

Document how to make the script run at startup.

=item *

Teach myself how to program in AutoHotkey properly.  Thereafter,
refactor this script.

I learned AutoHotkey on the go.  I have not read the documentation in
its entirety.  One day, I want to sit down and take the time to learn
AutoHotkey thoroughly.

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

=back

=cut

*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;                _                          _
; |\/| _  _| _  | \ _ ._  _ ._  _| _ .__|_ |_  ._  __|_o _ ._  _.|o_|_
; |  |(_)(_|(/_ |_/(/_|_)(/_| |(_|(/_| ||_ ||_|| |(_ |_|(_)| |(_||| |_\/
;                     |                                               /

mode_enabled := 0
toggle_flag  := 0
context_menu := 0
find         := 0
count        := 0
latest_key   := ""

; When holding down one of h, j, k, and l to scroll, do
; not receive a warning about exceeding the maximum
; number of hotkeys per interval.

A_HotkeyInterval := 0

GetCount()
{
	global count
	return count = 0 ? 1 : count
}

ResetCount()
{
	global count
	count := 0
}

UpdateCount(new_digit)
{
	global count
	existing_digits := count
	count := 10 * existing_digits + new_digit
}

; Select an item in Google Chrome's context menu

; .--------------------------.
; | Open in new tab          |
; | Open in new window       |
; | Open in incognito window |
; |--------------------------|
; | Edit...                  | 11
; |--------------------------|
; | Cut                      | 10
; | Copy                     |  9
; | Paste                    |  8
; |--------------------------|
; | Delete                   |  7
; |--------------------------|
; | Add page...              |  6
; | Add folder               |  5
; |--------------------------|
; | Bookmark Manager         |  4
; | Show apps shortcut       |  3
; | Show tab groups          |  2
; | Show Bookmarks bar       |  1
; .--------------------------.

AppsKey(num)
{
	delay := 750

	; We have to start from the bottom and move
	; upwards. Starting from the top and moving
	; downwards would not work because the top of
	; the context menu can change depending on
	; context.

	Send("{AppsKey}"),    Sleep(delay)
	Send("{Up " num "}"), Sleep(delay)
	Send("{Enter}"),      Sleep(delay)
}

; Check for a double key press

DoubleKeyPress()
{
	If (A_PriorHotkey = "")

		return ; guard

	timeout_duration := 300 ; milliseconds
	pressed_twice    := A_ThisHotkey = A_PriorHotkey
	pressed_quickly  := A_TimeSincePriorHotkey < timeout_duration

	return pressed_twice && pressed_quickly
}

; Accept a single keypress from the user

; Credit for this function goes to a post on the AutoHotkey forums.
; https://www.autohotkey.com/boards/viewtopic.php?t=122234#p542806

GetNextKeyPress()
{

	hook := InputHook("L1") ; L1 denotes a string of length 1

	hook.Start()
	hook.Wait()

	return hook.Input
}

#HotIf WinActive("ahk_class Chrome_WidgetWin_1")

\:: {

	If (!DoubleKeyPress()) {

		SendText("\")
		return

	} ; Guard

	global mode_enabled := !mode_enabled
}

#HotIf

Loop {

	If (mode_enabled) {

		If (!toggle_flag) { ; then entering mode

			toggle_flag := 1
			SoundBeep(1500)

			MouseGetPos(&xpos, &ypos) ; save mouse position
			MouseMove(0, 0)           ; move mouse out of way
			BlockInput("MouseMove")   ; disable mouse movement

			Send("^+b")               ; show bookmark bar
			Sleep(100)                ; give time to process
			Send("!+b")               ; focus on bookmark bar

		} ; else mode is already enabled

	} Else {

		If (toggle_flag) { ; then exiting mode

			toggle_flag := 0
			SoundBeep(1000)

			Send("{Alt}")              ; escape all drop down menus
			Send("^+b")                ; hide bookmark bar

			MouseMove(xpos, ypos)      ; restore mouse position
			BlockInput("MouseMoveOff") ; enable mouse movement

		} ; else mode is already disabled

	} ; If

	Sleep(25)

} ; Loop

#HotIf mode_enabled && !find

; Vim Keybindings

 0::UpdateCount(0)
 1::UpdateCount(1)
 2::UpdateCount(2)
 3::UpdateCount(3)
 4::UpdateCount(4)
 5::UpdateCount(5)
 6::UpdateCount(6)
 7::UpdateCount(7)
 8::UpdateCount(8)
 9::UpdateCount(9)
 a::return
+a::return
 b::return
+b::return
 c::return
+c::return
 d::
 {
 	if (DoubleKeyPress())

		AppsKey(7)
 }
+d::return
 e::
 {
	AppsKey(11)
	global mode_enabled := 0
 }
+e::return
 f::
 {
	global find := 1
	global latest_key := GetNextKeyPress()
	Loop GetCount()
	{
	       SendText(latest_key)
	}
	ResetCount()
	find := 0
 }
+f::return
 g::
 {
 	if (DoubleKeyPress())

		Send("{home}")
 }
+g::Send("{end}")
 h::
 {
	Send("{left " GetCount() "}")
	ResetCount()
 }
+h::return
 i::return
+i::return
 j::
 {
	Send("{down " GetCount() "}")
	ResetCount()
 }
+j::return
 k::
 {
	Send("{up " GetCount() "}")
	ResetCount()
 }
+k::return
 l::
 {
	Send("{right " GetCount() "}")
	ResetCount()
 }
+l::return
 m::AppsKey
+m::return
 n::return
+n::return
 o::return
+o::return
 p::AppsKey(8)
+p::return
 q::return
+q::return
 r::return
+r::return
 s::
 {
	delay := 750

	AppsKey(4)

	Send("{Tab}"),   Sleep(delay)
	Send("{Enter}"), Sleep(delay)
	Send("{Enter}"), Sleep(delay)
	Send("^w"),      Sleep(delay)
	Send("!+b")
 }
+s::return
 t::return
+t::return
 u::return
+u::return
 v::return
+v::return
 w::return
+w::return
 x::AppsKey(10)
+x::return
 y::AppsKey(9)
+y::return
 z::return
+z::return

`;::
{
	If (latest_key = "")

		return

	global find := 1
	SendText(latest_key)
	find := 0
}

*::
{
	AppsKey(4)
	global mode_enabled := 0
}

Capslock::{

	; If there is a count, cancel that.
	; Otherwise, escape out of all drop down menus.

	If (count = 0) {

		Send("{Alt}")

		/* I couldn't find documentation on this anywhere,
		 * but I've discovered that pressing the alt
		 * key--not as a modifier but by itself--will
		 * escape out of all drop dowm menus in Google
		 * Chrome.
		 */

	} Else {
		ResetCount()
	}
}

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

;               ___                               _
; |\/| _  _| _   | ._  _| _ ._  _ ._  _| _ .__|_ |_  ._  __|_o _ ._  _.|o_|_
; |  |(_)(_|(/_ _|_| |(_|(/_|_)(/_| |(_|(/_| ||_ ||_|| |(_ |_|(_)| |(_||| |_\/
;                           |                                               /

#HotIf WinActive("ahk_class Chrome_WidgetWin_1")

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

	if file = ""
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
