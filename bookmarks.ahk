;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FILENAME: bookmarks.ahk
; AUTHOR: Zachary Krepelka
; DATE: Friday, March 8th, 2024
; ABOUT: Chrome bookmarking optimizations
; UPDATED: Wednesday, September 11th, 2024 at 4:05 AM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; | \ _  _   ._ _  _ .__|_ _._|_o _ ._
; |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

/*
=pod

=head1 NAME

bookmarks.ahk - bookmarking optimizations for Google Chrome on Windows

=head1 SYNOPSIS

Using the Command Prompt:

=head2 Invocation

	start bookmarks.exe

=head2 Termination

	taskkill /IM bookmarks.exe

=head2 Compilation

	ahk2exe.exe /in bookmarks.ahk /out bookmarks.exe

	Using https://github.com/AutoHotkey/Ahk2Exe.git

=head1 DESCRIPTION

The purpose of this script is to provide an enhanced user interface method for
working with one's bookmarks in the Google Chrome web browser.  This script aims
to provide a Vim-like, keyboard-centric experience for bookmark management,
allowing the user to manage their bookmarks without the use of a mouse.

=head2 Usage

There are two modes: normal mode and bookmarking mode.  When the user is in
normal mode, the web browser will behave as expected; but when the user is in
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

There are several keybindings, some of which are context dependent.  The
keybindings are largely vim-inspired, meaning that you will use hjkl instead of
the arrow keys.

	  k
	h   l
	  j

=head2 Bookmarking Mode

=over

=item B<j>

Move down.  Used for scrolling through drop-down menus.

=item B<k>

Move up.  Used for scrolling through drop-down menus.

=item B<h>

Move to the left.  When in a nested drop-down menu, move into the parent
drop-down menu.

=item B<l>

Move to the right.  When on a folder, descend into that folder.

=item B<gg>

Move to the top of a drop-down menu.

=item B<G>

Move to the bottom of a drop-down menu.

=item B<f{char}>

Jump to the next entry in the drop-down menu whose name begins with {char}.

=item B<;>

Repeat the find command B<f{char}> with its most recent character.

=back

=head2 Mode Independent

The following keyboard shortcuts are available regardless of what mode you are
in.  These preform general functions.  Note that without the following
keybindings, one would need to click through many menus to perform the same
function.  Some of the keybindings perform complex UI operations, so it is best
to just sit back and let the computer "take the wheel" until execution finishes.

=over

=item B<CTRL+]>

Export your bookmarks to a HTML file.

=item B<CTRL+[>

Import your bookmarks from a HTML file.

=item B<ALT+]>

Remove the bookmark from the current page.

=item B<ALT+[>

Add or edit a bookmark.  When no bookmark exists for the current page, add one;
otherwise, edit the existing bookmark.  This will open Chrome's "Edit bookmark"
dialog, which looks like this.

	+----------------------------+
	| Edit bookmark              |
	|                            |
	| Name _____________________ |
	| URL  _____________________ |
	|                            |
	| +------------------------+ |
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

=item B<CTRL+\>

Create a new user profile.

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

The positioning of the mouse can distrust focus and consequently cause the
script to function improperly.  Make sure the mouse is not near the bookmark bar
or any pop-up menus when using a keybinding.

=head1 BUGS

Because this script was written in AutoHotkey, it only works on the Windows
operating system.  That's unfortunate.  :(

=head1 NOTES

You can compile this script so that the resulting executable has an icon by
using the following command.

	ahk2exe.exe /in bookmarks.ahk /out bookmarks.exe /icon bookmarks.ico

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

=head1

=cut
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; |_  ._  __|_o _ ._  _
; ||_|| |(_ |_|(_)| |_>

DoubleKeyPress()
{
	If (A_PriorHotkey = "")

		return ; Guard

	timeout_duration := 300 ; milliseconds
	pressed_twice    := A_ThisHotkey = A_PriorHotkey
	pressed_quickly  := A_TimeSincePriorHotkey < timeout_duration

	return pressed_twice && pressed_quickly
}

GetNextKeyPress()
{
	hook := InputHook("L1") ; L1 denotes a string of length 1.

	hook.Start()
	hook.Wait()

	return hook.Input
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;                _                          _
; |\/| _  _| _  | \ _ ._  _ ._  _| _ .__|_ |_  ._  __|_o _ ._  _.|o_|_
; |  |(_)(_|(/_ |_/(/_|_)(/_| |(_|(/_| ||_ ||_|| |(_ |_|(_)| |(_||| |_\/
;                     |                                               /

mode_enabled := 0
toggle_flag  := 0
context_menu := 0
find         := 0
latest_key   := ""

#HotIf WinActive("ahk_class Chrome_WidgetWin_1")

\:: {

	If (!DoubleKeyPress()) {

		SendText("\")
		return

	} ; Guard

	global mode_enabled

	mode_enabled := mode_enabled ? 0 : 1

}

#HotIf

Loop {

	If (mode_enabled) {

		If (!toggle_flag) { ; then entering mode

			toggle_flag := 1
			SoundBeep 1500

			BlockInput("MouseMove")    ; disable mouse movement
			Send("^+b")                ; show bookmark bar
			Sleep(100)                 ; give time to process
			Send("!+b")                ; focus on bookmark bar

		} ; else mode is already enabled

	} Else {

		If (toggle_flag) { ; then exiting mode

			toggle_flag := 0
			SoundBeep 1000

			Send("{Alt}")              ; escape all drop down menus
			Send("^+b")                ; hide bookmark bar
			BlockInput("MouseMoveOff") ; enable mouse movement

		} ; else mode is already disabled

	} ; If

	Sleep(25)

} ; Loop

#HotIf mode_enabled && !find

; Vim Keybindings

 a::return
+a::return
 b::return
+b::return
 c::return
+c::return
 d::return
+d::return
 e::return
+e::return
 f::
 {
	global find := 1
	global latest_key := GetNextKeyPress()
	SendText(latest_key)
	find := 0
 }
+f::return
 g::
 {
 	if (DoubleKeyPress())

		Send("{home}")
 }
+g::Send("{end}")
 h::Send("{left}")
+h::return
 i::return
+i::return
 j::Send("{down}")
+j::return
 k::Send("{up}")
+k::return
 l::Send("{right}")
+l::return
 m::return
+m::return
 n::return
+n::return
 o::return
+o::return
 p::return
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
 x::return
+x::return
 y::return
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

; The left and right mouse buttons are
; repurposed for interacting with
; bookmarks and their context menus.

LButton::
{

	; The left-hand mouse button sends the
	; enter key.  Use it to open a bookmark
	; or to select an item in a context menu.

	global

	context_menu := 0 ; closes after pressing enter

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

	global

	context_menu := !context_menu

	if (context_menu)
		Send("{AppsKey}")
	else
		Send("{Esc}")
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

; ADD OR EDIT A BOOKMARK

![::
{
	MouseMove(25, 115) ; the script fails if the mouse disrupts focus
	Send("{Ctrl down}d{Ctrl up}{Tab}{Enter}{Up}{Enter}")
	return
}

; DELETE A BOOKMARK

!]::
{
	MouseMove(25, 115)
	Send("{Ctrl down}d{Ctrl up}{Tab}{Tab}{Tab}{Enter}")
	return
}

Portation(file, num) { ; https://english.stackexchange.com/q/141717

	/*

	The purpose of this function is to import and export bookmarks
	to and from Google Chrome.  The first parameter is the file to
	import or export.  The second parameter is the number of key
	presses to access the proper menu item.  Pass 2 for exporting
	and 3 for importing.  Don't pass anything else for num.

	*/

	if file = ""   ; Then the file selection was canceled,
		return ; so don't do anything else.

	delay := 750

	Send("^t"),                      Sleep(delay)
	SendText("chrome://bookmarks "), Sleep(delay)
	Send("{Enter}"),                 Sleep(delay)
	Send("{Tab}"),                   Sleep(delay)
	Send("{Enter}"),                 Sleep(delay)
	Send("{Up " num "}"),            Sleep(delay)
	Send("{Enter}"),                 Sleep(delay)
	SendText(file),                  Sleep(delay)
	Send("{Enter}"),                 Sleep(delay)
	Send("^w")

	; The space after "chrome://bookmarks" breaks any autocompletion.

} ; Friday, April 26th, 2024

; IMPORT BOOKMARKS

^[::Portation(FileSelect(3  , , "Bookmark Importer", "*.html"), 3)

; EXPORT BOOKMARKS

^]::Portation(FileSelect("S", , "Bookmark Exporter", "*.html"), 2)

; APPLY BOOKMARKLET OVER MULTIPLE TABS.

F1::
{
	num := InputBox("Enter a number.").value

	Loop num {

		Send("!+b{Enter}^{Tab}")
		Sleep(500)

	}

} ; Monday, April 29th, 2024

; CREATE A NEW USER PROFILE IN GOOGLE CHROME

NewChromeUser() {

	delay := 750

	Send("!e"),        Sleep(delay)
	Send("{Down 4}"),  Sleep(delay)
	Send("{Enter}"),   Sleep(delay)
	Send("{Up 2}"),    Sleep(delay)
	Send("{Enter}"),   Sleep(delay)
	Send("{Tab 2}"),   Sleep(delay)
	Send("{Enter}"),   Sleep(delay)
	SendText("dummy"), Sleep(delay)
	Send("{Tab 2}"),   Sleep(delay)
	Send("{Enter}"),   Sleep(delay)
	Send("^t"),        Sleep(delay)
	Send("{Tab 3}"),   Sleep(delay)
	Send("{Enter}"),   Sleep(delay)
	Send("^w"),        Sleep(delay)

} ; Thursday, June 6th, 2024

^\::NewChromeUser()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
