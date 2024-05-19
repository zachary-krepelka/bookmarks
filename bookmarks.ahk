;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FILENAME: bookmarks.ahk
; AUTHOR: Zachary Krepelka
; DATE: Friday, March 8th, 2024
; ABOUT: Chrome bookmarking optimizations
; UPDATED: Sunday, May 19th, 2024 at 2:48 AM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;  _
; / \   _ ._ o _
; \_/\/(/_|\/|(/_\/\/

; PURPOSE

	; The purpose of this script is to provide an enhanced user interface
	; method for working with one's bookmarks in the Chrome web browser.
	; Here's how it works.  Press the backslash key to toggle bookmarking
	; mode on and off.  This mode changes the behavior of the mouse to make
	; it more easy to interact with bookmarks and their context menus.  Vim
	; keybindings are also provided.  Other mode independent hotkeys are
	; created as well.

	; While in bookmarking mode, the bookmark bar is visible.  Otherwise, it
	; is hidden.  This keeps your workspace looking clean and uncluttered.

; COMPLICATION

	; To compile this script, run this command.

	; ahk2exe.exe /in bookmarks.ahk /out bookmarks.exe /icon bookmarks.ico

	; You can get the icon here.

	; https://icon-icons.com/icon/bookmark-favorite-book/181573

; USAGE

	; To start the script:

		; cmd.exe /c start bookmarks.exe

	; To kill the script:

		; cmd.exe /c taskkill /IM bookmarks.exe

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;                _                          _
; |\/| _  _| _  | \ _ ._  _ ._  _| _ .__|_ |_  ._  __|_o _ ._  _.|o_|_
; |  |(_)(_|(/_ |_/(/_|_)(/_| |(_|(/_| ||_ ||_|| |(_ |_|(_)| |(_||| |_\/
;                     |                                               /

mode_enabled := 0
toggle_flag  := 0
conext_menu  := 0

#HotIf WinActive("ahk_class Chrome_WidgetWin_1")

\:: {

	global mode_enabled

	if (mode_enabled = 1)
		mode_enabled := 0
	else
		mode_enabled := 1

} ; hotkey

#HotIf

Loop {

	If (mode_enabled) {

		If (!toggle_flag) { ; then entering mode

			toggle_flag := 1

			BlockInput("MouseMove")    ; disable mouse movement
			Send("^+b")                ; show bookmark bar
			Sleep(100)                 ; give time to process
			Send("!+b")                ; focus on bookmark bar

		} ; else mode is already enabled

	} else {

		If (toggle_flag) { ; then exiting mode

			toggle_flag := 0

			Send("{Alt}")              ; escape all drop down menus
			Send("^+b")                ; hide bookmark bar
			BlockInput("MouseMoveOff") ; enable mouse movement

		} ; else mode is already disabled

	} ; if

	Sleep(25)

} ; loop

#HotIf mode_enabled

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

} ; hotkey

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
} ; hotkey

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

; Vim Keybindings

h::  Send("{left}")
j::  Send("{down}")
k::  Send("{up}")
l::  Send("{right}")
g::  Send("{home}")
+g:: Send("{end}")

#HotIf ; disable context sensitively

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;               ___                               _
; |\/| _  _| _   | ._  _| _ ._  _ ._  _| _ .__|_ |_  ._  __|_o _ ._  _.|o_|_
; |  |(_)(_|(/_ _|_| |(_|(/_|_)(/_| |(_|(/_| ||_ ||_|| |(_ |_|(_)| |(_||| |_\/
;                           |                                               /

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

; A hotkey to apply a bookmarklet over multiple tabs.  Put the bookmarklet that
; you want to run in the far left position of your bookmark bar.  Call this
; command and enter a number, say N.  The bookmarklet will be applied to the
; next N tabs.

F1::
{
	num := InputBox("Enter a number.").value

	Loop num {

		Send("!+b{Enter}^{Tab}")
		Sleep(500)

	}

} ; Monday, April 29th, 2024

; Works well with simple bookmarklets that alter the state of a webpage.

; Bookmarklets that

	; have popups
	; open new tabs
	; take too long

; won't work.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
