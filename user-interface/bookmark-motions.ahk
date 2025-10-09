; FILENAME: bookmark-motions.ahk
; AUTHOR: Zachary Krepelka
; DATE: Friday, March 8th, 2024
; DOCS: perldoc bookmark-motions.ahk
; ABOUT: Vim motions for bookmark management
; ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
; UPDATED: Thursday, October 9th, 2025 at 4:53 PM

VERSION := "v1.0.0"

; Directives -------------------------------------------------------------- {{{1

#Requires AutoHotkey v2

#SingleInstance Force

#Include UIA.ahk

; Classes ----------------------------------------------------------------- {{{1

class Mode {

	State := false

	Enter() {
		this.State := true
	}

	Exit() {
		this.State := false
	}

	IsEnabled() {
		return this.State
	}

	Toggle() {
		if this.IsEnabled() {
			this.Exit()
		} else {
			this.Enter()
		}
	}
}

class AudibleMode extends Mode {

	EnterVolume := 1500
	ExitVolume  := 1000
	IsAudible   := true

	Mute() {
		this.IsAudible := false
	}

	Unmute() {
		this.IsAudible := true
	}

	Enter() {
		super.Enter()
		if this.IsAudible
			SoundBeep(this.EnterVolume)
	}

	Exit() {
		super.Exit()
		if this.IsAudible
			SoundBeep(this.ExitVolume)
	}
}

class BypassableHotkeyMode extends AudibleMode {

	BypassMode := Mode()

	Halt() {
		this.BypassMode.Enter()
	}

	Resume() {
		this.BypassMode.Exit()
	}

	PermitsHotkeys() {

		; To be used in conjunction with the #HotIf directive.

		return this.IsEnabled() && !this.BypassMode.IsEnabled()
	}

	BypassUntil(Keys, Callback := false) {

		this.Halt()

		OnKeyDown(Hook, VirtualKey, ScanKey) {
			for Candidate in Keys {
				if Candidate = VirtualKey {
					Hook.Stop()
					if Callback
						Callback.Call()
					this.Resume()
					return
				}
			}
		}

		Hook := InputHook("V")
		Hook.KeyOpt("{All}", "+N")
		Hook.OnKeyDown := OnKeyDown
		Hook.Start()
	}
}

class BookmarkMode extends BypassableHotkeyMode {

	IsDynamic := false

	Enter() {
		super.Enter()
		Mouse.Pointer.Disable()
		if this.IsDynamic
			BookmarksBar.Toggle() ; On
		BookmarksBar.Focus()
		MouseBehavior.Reset()
	}

	Exit() {
		super.Exit()
		BookmarksBar.EscapeDropDownMenus()
		if this.IsDynamic
			BookmarksBar.Toggle() ; Off
		WebPage.Focus()
		Mouse.Pointer.Enable()
	}

	PermitsHotkeys() {
		return super.PermitsHotkeys() && Browser.IsActive()
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

		for Id, Executable in this.EXECUTABLES {

			if WinActive("ahk_exe " Executable ".exe") {

				return Id
			}
		}
		return this.UNKNOWN
	}

	static IsActive() {

		return !!this.Identity()
	}
}

class WebPage {

	static Focus() {

		switch Browser.Identity() {

			case Browser.CHROME, Browser.EDGE:

				Send("^{F6}")

			case Browser.FIREFOX:

				Send("{F6}")

			case Browser.OPERA:

				Send("{F9}")
		}
	}
}

class BookmarksBar {

	static Toggle() {

		switch Browser.Identity() {

			case Browser.CHROME, Browser.EDGE, Browser.FIREFOX:

				Send("^+b")

			case Browser.OPERA:

				Send("{Esc}")
				Send("{F10}")
				Send("{Enter}")
				Send("b")
				Send("s")
		}
	}

	static Focus() {

		switch Browser.Identity() {

			case Browser.CHROME, Browser.EDGE:

				Send("!+b")

			case Browser.FIREFOX:

				Delay := 100

				Send("{Esc 2}"),     Sleep(Delay)
				Send("^l"),          Sleep(Delay)
				Send("{Backspace}"), Sleep(Delay)
				Send("{Tab 2}")

			case Browser.OPERA:

				; assumes that Opera's sidebar is visible

				; TODO use the UIA library to determine if the
				; sidebar is visible and adapt accordingly

				Send("{F10}{F6 3}")
		}
	}

	static EscapeDropDownMenus() {

		/* I couldn't find documentation on this anywhere, but
		 * I've discovered that pressing the alt key not as a
		 * modifier but by itself will escape out of all
		 * drop-down menus in some web broswers.
		 */

		Send("{Alt}")

		if Browser.Identity() = Browser.FIREFOX

			Send("{Esc}")
	}
}

class Mouse {

	class Pointer {

		static Save() {

			MouseGetPos(&x, &y)
			this.x := x
			this.y := y
		}

		static Disable() {

			this.Save()
			MouseMove(0, 0)
			BlockInput("MouseMove")
		}

		static Enable() {

			MouseMove(this.x, this.y)
			BlockInput("MouseMoveOff")
		}
	}
}

class MouseBehavior {

	static DefaultScrollOrientation := true

	static Reset() {

		this.horizontal_scroll  := this.DefaultScrollOrientation
		this.context_menu       := false
		this.pending_transition := false
	}

	static ToggleScrollDirection() {

		; FIXME shouldn't be used when context menu is active

		BookmarksBar.EscapeDropDownMenus()

		this.horizontal_scroll ^= 1
	}

	static OnWheelUp() {

		Send(this.horizontal_scroll ? "{left}" : "{up}")
	}

	static OnWheelDown() {

		Send(this.horizontal_scroll ? "{right}" : "{down}")
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
}

class Counter {

	static SAFETY_LIMIT := 100

	Count := 0

	Get() {
		return this.Count || 1
	}

	Reset() {
		this.Count := 0
	}

	Update(NewDigit) {

		ExistingDigits := this.Count

		CandidateCount := 10 * ExistingDigits + NewDigit

		if CandidateCount > Counter.SAFETY_LIMIT {

			NotifyMisuse()

			return
		}

		this.Count := CandidateCount
	}

	IsPending() {

		return this.Count
	}
}

class ThisHotkey {

	__New(TimeoutDuration) {
		this.TimeoutDuration := TimeoutDuration
	}

	WasPrefixedBy(Key) {

		if !A_PriorHotkey
			return false

		Prefixed := Key == A_PriorHotkey
		PrefixedQuickly := A_TimeSincePriorHotkey < this.TimeoutDuration

		return Prefixed && PrefixedQuickly
	}

	WasDoublePressed() {
		return this.WasPrefixedBy(A_ThisHotkey)
	}

	DispatchByPressType(SinglePressEvent, DoublePressEvent) {

		if this.WasDoublePressed() {
			SetTimer SinglePressEvent, 0
			DoublePressEvent.Call()
		} else {
			SetTimer SinglePressEvent, -this.TimeoutDuration
		}
	}

	HookDoubleKeypress(Event) {
		this.DispatchByPressType(() => SendText(A_ThisHotkey), Event)
	}
}

class Context {

	__New() {
		this.Elem := UIA.GetFocusedElement()
	}

	IsBookmark() {
		return !this.IsFolder()
	}

	IsFolder() {

		if Browser.Identity() = Browser.FIREFOX {

			if this.IsInDropDown()
				return this.Elem.IsExpandCollapsePatternAvailable

			Send("{AppsKey}")
			Send("{Down}")
			Sleep(200)

			FirstContextMenuItem := UIA.GetFocusedElement()

			Result := (
				FirstContextMenuItem.AutomationId =
				"placesContext_openBookmarkContainer\:tabs"
			)

			Send("{Alt}")
			Sleep(200)

			return Result
		}

		return this.Elem.IsExpandCollapsePatternAvailable
	}

	IsOnBar() {
		return this.Elem.Type = 50000 || (
			Browser.Identity() = Browser.OPERA &&
			this.Elem.LocalizedType =
			"Bookmark folder button"
		)
	}

	IsInDropDown() {
		return !this.IsOnBar()
	}
}

class ContextMenuSelector {

	/**
	 * Select an item in a context menu by its access key
	 *
	 * Note that calling with count = 1 requires the user to
	 * send enter after the call if the letter is not unique
	 * in the dropdown menu.
	 */

	static SelectByLetter(letter, count := 1) {

		Send("{AppsKey}")

		Loop count
			SendText(letter)

		if count > 1
			Send("{Enter}")
	}

	static SelectByNumber(number, direction) {

		Send("{AppsKey}")

		if Browser.Identity() = Browser.FIREFOX
			Send("{Down}")

		Send("{" direction " " number "}")

		Send("{Enter}")
	}

	static SelectNthFromTop(Nth) {

		this.SelectByNumber(Nth - 1, "Down")
	}

	static SelectNthFromBottom(Nth) {

		this.SelectByNumber(Nth, "Up")
	}
}

class ChangeMonitor {

	__New(aTimeout) {

		this.TimeToChange := aTimeout
	}

	Probe() {

		return A_TickCount
	}

	HasChanged() {

		return this.Before != this.After
	}

	Catalyze(Antecedent, Consequent) {

		Callback := ObjBindMethod(this, "Consummate", Consequent)

		this.Before := this.Probe()

		Antecedent.Call()

		SetTimer Callback, -this.TimeToChange
	}

	Consummate(Consequent) {

		this.After := this.Probe()

		if this.HasChanged()
			Consequent.Call()
	}
}

class TabChangeMonitor extends ChangeMonitor {

	Probe() {
		return WinGetTitle("A")
	}
}

; Monkey patch a contains method to the array prototype

ArrayContains(this, Target, CaseSensitive := true) {

	for _, Item in this {

		if CaseSensitive && Item == Target ||
		  !CaseSensitive && Item =  Target {
			return true
		}
	}
	return false
}

Array.Prototype.DefineProp("Contains", {Call: ArrayContains})

class CommandLine {

	Options := Map()
	Arguments := Array()
	Invalid := Array()

	__New(IsCaseSensitive) {
		this.IsCaseSensitive := IsCaseSensitive
	}

	HasOption(OptionName) {

		if !this.IsCaseSensitive
			OptionName := StrLower(OptionName)

		return this.Options.Has(OptionName)
	}

	GetOption(OptionName) {

		if !this.IsCaseSensitive
			OptionName := StrLower(OptionName)

		return this.Options.Get(OptionName)
	}
}

class CommandLineParser {

	__New(IsCaseSensitive) {
		this.IsCaseSensitive := IsCaseSensitive
	}

	/**
	 * Parse tokens according to specification
	 */

	Parse(Tokens, Specification) {

		Command := CommandLine(this.IsCaseSensitive)

		for n, Token in Tokens {

			if (SubStr(Token, 1, 1) = "/") {

				Parts := StrSplit(SubStr(Token, 2), ":", "", 2)

				OptName := Parts[1]

				if !this.IsCaseSensitive
					OptName := StrLower(OptName)

				OptArg := Parts.Length > 1 ? Parts[2] : ""

				if Specification.Contains(OptName, this.IsCaseSensitive)
					Command.Options[OptName] := OptArg
				else
					Command.Invalid.Push(OptName)

			} else Command.Arguments.Push(Token)
		}
		return Command
	}
}

; Functions --------------------------------------------------------------- {{{1

Usage() {

	HelpMessage := Gui("+AlwaysOnTop", "Bookmark Motions Usage")

	; in the style of the Windows Command Prompt

	HelpMessage.BackColor := "Black"
	HelpMessage.SetFont("cWhite", "Consolas")

	HelpMessage.AddText(,
	"Interpret Vim Motions for Bookmark Management"                                    . "`n"
	""                                                                                 . "`n"
	"BOOKMARK-MOTIONS [/BAR:DYNAMIC | /BAR:STATIC] [/SCROLL:HORIZ | /SCROLL:VERT]"     . "`n"
	"                 [/MUTE] [/VER] [/?]"                                             . "`n"
	""                                                                                 . "`n"
	"  /BAR:DYNAMIC Toggle the bookmarks bar when changing modes.  Show the bookmarks" . "`n"
	"               bar when entering bookmark mode.  Hide the bookmarks bar when"     . "`n"
	"               exiting bookmark mode.  Assumes that bookmark mode is entered"     . "`n"
	"               with the bar initially hidden.  Can possibly fall out of sync."    . "`n"
	"  /BAR:STATIC  Do not toggle the bookmarks bar when changing modes.  This is the" . "`n"
	"               default behavior.  Assumes that the bookmarks bar is always"       . "`n"
	"               visible."                                                          . "`n"
	"  /SCROLL:ORI  Determines the mouse wheel's initial scrolling orientation when"   . "`n"
	"               entering bookmark mode.  ORI is either HORIZ or VERT.  The"        . "`n"
	"               default initial scrolling orientation is horizontal."              . "`n"
	"  /MUTE        Do not beep when changing modes."                                  . "`n"
	"  /VER         Display the version number and exit."                              . "`n"
	""                                                                                 . "`n"
	"This program intercepts keyboard input to a web browser to interpret those"       . "`n"
	"keystrokes as Vim motions.  There are two modes."                                 . "`n"
	""                                                                                 . "`n"
	"    1.  In standard mode, the web browser behaves normally."                      . "`n"
	""                                                                                 . "`n"
	"    2.  In bookmark mode, focus is redirected to the bookmarks bar where Vim"     . "`n"
	"        motions can be used to navigate one's bookmarks and folders."             . "`n"
	""                                                                                 . "`n"
	"Bookmark mode is toggled by pressing backslash twice in quick succession."        . "`n"
	"Check https://github.com/zachary-krepelka/bookmarks/releases for updates."        . "`n"
	)

	HelpMessage.Show()
	WinWaitClose(HelpMessage.Hwnd)
	ExitApp
}

Main() {

	global MainProcessed := false
	global BookmarkModeInstance := BookmarkMode()
	global CommandQuantifier := Counter()
	global ActiveHotkey := ThisHotkey(300)

	ValidOptions := ["BAR", "SCROLL", "MUTE", "VER", "?"]

	Cmd := CommandLineParser(false).Parse(A_Args, ValidOptions)

	; TODO notify invalid options, exit prematurely

	if Cmd.HasOption("?")
		Usage()

	if Cmd.HasOption("VER") {

		Text    := Format("Version {}", SubStr(VERSION, 2))
		Title   := "Bookmark Motions"
		Options := "Iconi"

		MsgBox(Text, Title, Options)

		ExitApp
	}

	if Cmd.HasOption("BAR") {

		OptArg := Cmd.GetOption("BAR")

		if OptArg = "DYNAMIC"
			BookmarkModeInstance.IsDynamic := true

		if OptArg = "STATIC"
			BookmarkModeInstance.IsDynamic := false
	}

	if Cmd.HasOption("SCROLL") {

		OptArg := Cmd.GetOption("SCROLL")

		if OptArg = "HORIZ"
			MouseBehavior.DefaultScrollOrientation := true

		if OptArg = "VERT"
			MouseBehavior.DefaultScrollOrientation := false
	}

	if Cmd.HasOption("MUTE")
		BookmarkModeInstance.Mute()

	MainProcessed := true
}

/**
 * Accept a single keypress from the user
 *
 * Credit for this function goes to a post on the AutoHotkey forums.
 * https://www.autohotkey.com/boards/viewtopic.php?t=122234#p542806
 */

GetNextKeyPress() {

	Hook := InputHook("L1") ; L1 denotes a string of length one
	Hook.Start()
	Hook.Wait()
	return Hook.Input
}

NotifyMisuse() {
	SoundPlay("*16")
}

Move(direction) {
	Send("{" direction " " CommandQuantifier.Get() "}")
	CommandQuantifier.Reset()
}

Escape() {
	if CommandQuantifier.isPending()
		CommandQuantifier.Reset()
	else
		BookmarksBar.EscapeDropDownMenus()
}

Find() {
	global Target

	BookmarkModeInstance.Halt()

	Target := GetNextKeyPress()

	Loop CommandQuantifier.Get()
		SendText(Target)

	CommandQuantifier.Reset()

	BookmarkModeInstance.Resume()
}

Repeat() {
	if !IsSet(Target) {
		NotifyMisuse()
		return
	}

	BookmarkModeInstance.Halt()

	Loop CommandQuantifier.Get()
		SendText(Target)

	CommandQuantifier.Reset()

	BookmarkModeInstance.Resume()
}

/**
 * A function to send the home key with a workaround for Firefox
 */

Home() {
	if Browser.Identity() = Browser.FIREFOX && Context().IsOnBar() {

		EnoughToReachLeftSide := 60

		Send("{Left " EnoughToReachLeftSide "}")

	} else Send("{Home}")
}

/**
 * A function to send the end key with a workaround for Firefox
 */

End() {
	if Browser.Identity() = Browser.FIREFOX && Context().IsOnBar() {

		EnoughToReachRightSide := 60

		Send("{Right " EnoughToReachRightSide "}")

	} else Send("{End}")
}

GotoAbsolute() {

	BookmarksBar.EscapeDropDownMenus()

	if Browser.Identity() = Browser.FIREFOX
		Sleep(100)

	Home()

	if Browser.Identity() = Browser.FIREFOX
		Sleep(100)

	Move("Right")
}

FirefoxRefocusElement() {

	Send("{Down}{Up}")
}

; Hotkeys ----------------------------------------------------------------- {{{1

Main()

/* debugging only

F12::{
	C := Context()
	Part1 := C.IsBookmark() ? "bookmark" : "folder"
	Part2 := C.IsOnBar()    ? "on bar"   : "in drop-down"
	MsgBox(Part1 " " Part2)
}
*/

#HotIf MainProcessed && Browser.IsActive()
\::ActiveHotkey.HookDoubleKeypress(() => BookmarkModeInstance.Toggle())
XButton1::{

	Held := false
	Timeout := 1000
	Start := A_TickCount

	Loop {
		IsDown := GetKeyState("XButton1", "P")
		HowLong := A_TickCount - Start

		if !IsDown
			Break

		if HowLong > Timeout {
			Held := true
			Break
		}
	}
	if Held
		BookmarkModeInstance.Toggle()
	else if BookmarkModeInstance.PermitsHotkeys()
		MouseBehavior.ToggleContextMenu()
}
#HotIf

#HotIf BookmarkModeInstance.PermitsHotkeys()
 0::{
	if CommandQuantifier.IsPending()
		CommandQuantifier.Update(0)
	else
		Home()
 }
 1::CommandQuantifier.Update(1)
 2::CommandQuantifier.Update(2)
 3::CommandQuantifier.Update(3)
 4::CommandQuantifier.Update(4)
 5::CommandQuantifier.Update(5)
 6::CommandQuantifier.Update(6)
 7::CommandQuantifier.Update(7)
 8::CommandQuantifier.Update(8)
 9::CommandQuantifier.Update(9)
 a::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(6)
			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])

		case Browser.EDGE:

			; Only partially adds the bookmark at the location
			; correspondent to where the action was performed.  The
			; bookmark appears in the correct folder but not near
			; the bookmark that the context menu was spawned from.
			; Instead, it is placed at the bottom of the folder /
			; end of the bookmarks bar.

			ContextMenuSelector.SelectNthFromBottom(5)
			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])

		case Browser.FIREFOX:

			; does not autofill with the current page

			ContextMenuSelector.SelectByLetter("b")

			Send("{Enter}")

			BookmarkModeInstance.BypassUntil([0x0D, 0x1B],

				() => BookmarksBar.Focus()
			)

		case Browser.OPERA:

			; Unlike other web browsers, Opera does not have items
			; in its *bookmark* context menu to add a new bookmark
			; or folder. However, these items do appear in its
			; *folder* context menu.

			if Context().IsBookmark()
				NotifyMisuse()
			else {

				; Must be selected from the bottom.  Selecting
				; from the top requires knowlege of how many
				; Opera Workspaces are visible on the sidebar.

				ContextMenuSelector.SelectNthFromBottom(4)
				BookmarkModeInstance.BypassUntil([0x0D, 0x1B])
			}
	}
}
+a::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(5)
			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])

		case Browser.EDGE:

			ContextMenuSelector.SelectNthFromBottom(4)
			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])

		case Browser.FIREFOX:

			ContextMenuSelector.SelectByLetter("f")

			BookmarkModeInstance.BypassUntil([0x0D, 0x1B],

				() => BookmarksBar.Focus()
			)

		case Browser.OPERA:

			; see notes in previous switch statement

			if Context().IsBookmark()
				NotifyMisuse()
			else {
				ContextMenuSelector.SelectNthFromBottom(3)
				BookmarkModeInstance.BypassUntil([0x0D, 0x1B])
			}
	}
}
 b::return
+b::return
 c::return
+c::return
 d::{
 	if !ActiveHotkey.WasDoublePressed()
		return

	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(7)

		case Browser.EDGE:

			ContextMenuSelector.SelectNthFromTop(9)

		case Browser.FIREFOX:

			ContextMenuSelector.SelectByLetter("d")

			if Browser.Identity() = Browser.FIREFOX &&
			   Context().IsOnBar() {
				BookmarksBar.Focus()
			}

		case Browser.OPERA:

			ContextMenuSelector.SelectByLetter("m")
	}
 }
+d::return
 e::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(11)
			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])

		case Browser.EDGE:

			if Context().IsBookmark()
				ContextMenuSelector.SelectNthFromTop(4)
			else
				ContextMenuSelector.SelectNthFromTop(5)

			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])

		case Browser.FIREFOX:

			if Context().IsBookmark()
				ContextMenuSelector.SelectNthFromTop(4)
			else
				ContextMenuSelector.SelectNthFromTop(2)

			BookmarkModeInstance.BypassUntil([0x0D, 0x1B],

				() => BookmarksBar.Focus()
			)

		case Browser.OPERA:

			; Must be selected from the bottom.  Selecting from the
			; top requires knowlege of how many Opera Workspaces are
			; visible on the sidebar.

			if Context().IsBookmark()
				ContextMenuSelector.SelectNthFromBottom(4)
			else
				ContextMenuSelector.SelectNthFromBottom(6)

			BookmarkModeInstance.BypassUntil([0x0D, 0x1B])
	}
 }
+e::return
 f::TabChangeMonitor(1000).Catalyze(() => Find(), () => BookmarksBar.Focus())
+f::return
 g::{
	if !ActiveHotkey.WasDoublePressed()
		return

	if CommandQuantifier.IsPending()
		GotoAbsolute()
	else
		Home()
 }
+g::{
	if CommandQuantifier.IsPending()
		GotoAbsolute()
	else
		End()
}
 h::Move("Left")
+h::return
 i::return
+i::return
 j::Move("Down")
+j::return
 k::Move("Up")
+k::return
 l::Move("Right")
+l::return
 m::AppsKey
+m::return
 n::return
+n::return
 o::{
	if Context().IsFolder() {
		NotifyMisuse()
		return
	}

	Send("{Enter}")

	BookmarkModeInstance.Toggle()

	if Browser.Identity() = Browser.FIREFOX {
		Sleep(300)
		WebPage.Focus()
	}

	if Browser.Identity() = Browser.OPERA
		Send("{Esc}")
 }
+o::{
	if Browser.Identity() = Browser.OPERA {

		if Context().IsBookmark()
			ContextMenuSelector.SelectNthFromTop(2)
		else
			ContextMenuSelector.SelectNthFromTop(1)

		return
	}

	ContextMenuSelector.SelectNthFromTop(1)

	if Browser.Identity() = Browser.FIREFOX {
		Sleep(300)
		BookmarksBar.Focus()
	}
 }
 p::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(8)

		case Browser.EDGE:

			ContextMenuSelector.SelectNthFromTop(8)

		case Browser.FIREFOX:

			WasInDropDownPriorOperation := Context().IsInDropDown()

			if Context().IsBookmark()
				ContextMenuSelector.SelectNthFromTop(8)
			else
				ContextMenuSelector.SelectNthFromTop(7)

			if  WasInDropDownPriorOperation
				FirefoxRefocusElement()

		case Browser.OPERA:

			; Sadly, the standard cut, copy, and paste items
			; do not appear in Opera's bookmark bar context
			; menus.  Not sure what to do here.

			NotifyMisuse()
	}
}
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
 x::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(10)

		case Browser.EDGE:

			ContextMenuSelector.SelectNthFromTop(6)

		case Browser.FIREFOX:

			WasInDropDownPriorOperation := Context().IsInDropDown()

			ContextMenuSelector.SelectByLetter("t")

			if  WasInDropDownPriorOperation
				FirefoxRefocusElement()

		case Browser.OPERA:

			NotifyMisuse()
	}
}
+x::return
 y::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(9)

		case Browser.EDGE:

			ContextMenuSelector.SelectNthFromTop(7)

		case Browser.FIREFOX:

			WasInDropDownPriorOperation := Context().IsInDropDown()

			ContextMenuSelector.SelectByLetter("c")

			if  WasInDropDownPriorOperation
				FirefoxRefocusElement()

		case Browser.OPERA:

			NotifyMisuse()
	}
 }
+y::return
 z::return
+z::return
$::End()
*::{
	switch Browser.Identity() {

		case Browser.CHROME:

			ContextMenuSelector.SelectNthFromBottom(4)
			BookmarkModeInstance.Toggle()

		case Browser.EDGE:

			ContextMenuSelector.SelectNthFromBottom(1)
			BookmarkModeInstance.Toggle()

		case Browser.FIREFOX:

			; I need to think about this.  The bookmark
			; manager opens in its own window.  Because
			; focus is redirected to the new window, we
			; cannot exit bookmarking mode.

			NotifyMisuse()

		case Browser.OPERA:

			; does not open to the location correspondent to
			; where it was selected from

			ContextMenuSelector.SelectNthFromBottom(2)
			BookmarkModeInstance.Toggle()
	}
}
^::Home()
`;::TabChangeMonitor(1000).Catalyze(() => Repeat(), () => BookmarksBar.Focus())
Escape::Escape()
CapsLock::Escape()
Enter::TabChangeMonitor(1000).Catalyze(() => Send("{Enter}"), () => BookmarksBar.Focus())
WheelUp::MouseBehavior.OnWheelUp()
WheelDown::MouseBehavior.OnWheelDown()
LButton::MouseBehavior.OnLeftClick()
RButton::MouseBehavior.OnRightClick()
MButton::MouseBehavior.ToggleScrollDirection() ; should only use in certain contexts
XButton2::{
	Send("{Enter}")
	BookmarkModeInstance.Toggle()
}
#HotIf

; Miscellaneous ----------------------------------------------------------- {{{1

; The remaining code is Chrome-specfic and needs refactored.

#HotIf MainProcessed && WinActive("ahk_exe chrome.exe") && !BookmarkModeInstance.IsEnabled() && MainProcessed

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

; Documentation ----------------------------------------------------------- {{{1

/*
=pod

=head1 NAME

bookmark-motions.exe - Vim motions for bookmark management

=head1 SYNOPSIS

Using the Windows Command Prompt:

=over

=item Invocation

 start bookmark-motions.exe [OPTIONS]

Use option C</?> to see other options.

=item Termination

 taskkill /im bookmark-motions.exe

=item Compilation

 Ahk2Exe.exe /base AutoHotkey64.exe
             /in bookmark-motions.ahk
             /out bookmark-motions.exe
             /icon bookmark-motions.ico

See the COMPILATION section for detailed instructions.

=back

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

Opera, Opera GX, & Opera Air

=back

Because this script is written in AutoHotkey, it will only run on Windows.  I am
in the process of writing a port for Linux using the AHK_X11 project.

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
also do this with the mouse by holding the side button until a beep is heard.
The full range of commands are documented in a later section.

=head1 OPTIONS

The options to this program facilitate user preference configuration.  This
program implements a command-line interface in the style of the Windows command
interpreter C<cmd.exe> and its family of built-ins.  To be brief, the Unix-style
option syntax C<-f filename> would be translated as C</F:FILENAME>.  These
options can be used in a Windows shortcut file.

=over

=item B</BAR:DYNAMIC>

Passing this option causes the visibility of the bookmarks bar to toggle on and
off when changing modes.  The intention is to show the bookmarks bar when
entering bookmark mode and to hide the bookmarks bar when exiting bookmark mode.
B<This assumes that bookmark mode is entered with the bar initially hidden.>

It is possible for this process to fall out of sync.  The bookmarks bar might
appear when *exiting* bookmark mode and disappear when *entering* bookmark mode.
This is undesirable.  It can be fixed by manually toggling the bookmarks bar,
usually with C<CTRL + SHIFT + B>, but it depends on the browser.

Hiding the bookmarks bar when it is not in use keeps your workspace looking
clean by reducing visual clutter.  It's a means of maximizing screen real estate
and reducing digital overload.

=item B</BAR:STATIC>

Do not toggle the bookmarks bar when changing modes.  This has the opposite
effect of C</BAR:DYNAMIC> and is the default behavior.  B<This assumes that the
bookmarks bar is always visible.>

This flag is mutually exclusive with C</BAR:DYNAMIC>.  The last one to be
specified on the command-line will take priority.

=item B</SCROLL:>I<ORI>

This option's argument determines the initial scroll orientation of the mouse
wheel when entering bookmark mode.  To understand what this means, the user
should read the section titled MOUSE ACTIONS.  Here ORI can be either HORIZ or
VERT.

In essence, bookmarking mode enables the bookmarks bar to be navigated using a
mouse.  Two scrolling orientations exist, horizontal and vertical, which are
toggled between during a typical mouse-driven workflow.

When the user enters bookmark mode, the mouse refreshes to an initial scrolling
orientation.  The default initial scrolling orientation is horizontal, i.e., the
mouse wheel scrolls the focus ring horizontally across the bookmarks bar.

The user can change the default initial scrolling orientation using this option.
A vertical scrolling orientation is useful when the first item on the bookmarks
bar--where focus is initially placed when entering bookmark mode--is a folder
that can be dropped into.

The two viable arguments to this option--HORIZ and VERT--are mutually exclusive.
The last one to be specified on the command line takes priority.

=item B</MUTE>

When entering or exiting bookmark mode, an audible beep plays.  This option
disables that behavior.  Beeps will still be heard for errors.  (This may be
subject to change in the future).

The C</MUTE> option is relevant when used in conjunction with the
C</BAR:DYNAMIC> flag.  The toggling of the bar visually indicates the mode
change, so beeps are not needed.

=item B</VER>

Display the version number and exit.

=item B</?>

Display a help message in a pop-up dialog.  Exit the program when the user exits
the window.

=back

=head1 KEYBINDINGS

This section documents the keybindings available in each mode.  The majority of
them are concentrated in bookmark mode.  Standard mode contains some odds and
ends but otherwise aims to be unintrusive.

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

=item B<Esc>

If there is a pending [count], cancel that; otherwise, escape out of all
drop-down menus.  Unlike in Vim, the escape key does not exit a mode.

=item B<Caps Lock>

Performs the same function as the escape key.

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

=item B<gg>

Move to the top of a drop-down menu (or to the beginning of the bookmarks bar).

Noting that the bookmarks bar lays out bookmarks horizontally instead of the
vertical arrangement seen in drop down menus, these aliases will feel more
natural to Vim users on the bookmarks bar.

=over

=item S< >^

Move to the beginning of the bookmark bar.

=item S< >0

Move to the beginning of the bookmark bar, provided that a count is not pending.

=back

There is no actual distinction in functionality; all three can be used
interchangeably.  An exception to this rule follows.

When C<gg> is prefixed with a [count], focus will be put on the [count]th item
on the bookmarks bar, counting from zero.  Any drop-down menus are escaped.

=item B<G>

Move to the bottom of a drop-down menu (or to the end of the bookmarks bar).

Again noting that the bookmark bar lays out bookmarks horizontally instead of
the vertical arrangement seen in drop down menus, this alias will feel more
natural to Vim users on the bookmarks bar.

=over

=item $ Move to the end of the bookmark bar.

=back

There is no actual distinction in functionality; G and $ can be used
interchangeably.  An exception to this rule follows.

When C<G> is prefixed with a [count], it will have the same effect as prefixing
C<gg> with a count.  See above.

=item B<f{char}>

Jump to the next entry in the drop-down menu whose name begins with {char}.
When prefixed with a number, jump to the [count]th occurrence after the current
selection.  Does not work on the bookmarks bar.

=item B<;>

Repeat the find command B<f{char}> with its most recent character.  The count is
not carried over, but this motion accepts its own [count].

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

=item B<o>

Open the currently selected bookmark and exit bookmarking mode.  Not
intended to be used on a folder.

=item B<O>

Open the currently selected bookmark in a new tab.  If over a folder,
open all items in that folder.  Does *NOT* leave bookmarking mode.

=item B<e>

Edit the currently selected bookmark or folder.  Causes a dialog to appear.

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

To allow the user to type freely, bookmark-mode keybindings are temporarily
bypassed until the user presses enter (as in save) or escape (as in cancel).

=item B<a>

Add a new bookmark near the currently selected bookmark or folder.  This command
is similar to the edit command.  A pop-up dialog opens where the user can type
freely until either enter or escape is pressed.  The difference is that this
command adds a new bookmark instead of editing an existing one.

The exact behavior of this command depends on the web browser in use.  The
desired behavior is that the bookmark will be created

=over

=item * to the immediate left of the currently selected item if that item is a
bookmark on the bookmarks bar.

=item * directly under the currently selected item if that item is a bookmark in
a drop-down menu.

=item * inside of the currently selected item if that item is a folder.

=back

This is not the behavior on all web browsers.  Differences will be documented in
the COMPATIBILITY section at a later time.  Also, the dialog may or may not be
autofilled with the current page title and URL, again depending on the browser.

=item B<A>

Add a new folder near the currently selected bookmark or folder.  This is like
the lowercase B<a> command, but it adds a new folder instead of a new bookmark.
It is also subject to the same issues as the lowercase B<a> command.

=item B<*> (asterisk)

Leave bookmarking mode and open the bookmark manager.  If your web browser
supports it, the bookmark manager will be opened to the currently selected
bookmark or folder.

Think of this as a fallback.  What cannot be done in bookmarking mode can be
done in the bookmark manager with the mouse.

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
you want to run in the far left position of your bookmarks bar.  Call this
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

This script makes it possible to navigate the bookmarks bar and the drop-down
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

To enter and exit bookmarking mode with the mouse, hold down the first side
button until a beep is heard.  (If you are unsure which side button is which,
try them both.  A typical mouse has two.)

Before getting into the particulars, let's address some preliminary knowledge.
There are two environments that you will be working from when managing your
bookmarks.

=over

=item 1 The Bookmarks Bar

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

The initial scroll orientation can be changed with the C</SCROLL> command-line
option.  When the user enters bookmarking mode, the scroll orientation is
initially horizontal by default.  Having an initially vertical scrolling
orientation is useful if the first item on the bookmarks bar is a
(deeply-nested) folder.

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

If held down until a beep is heard, toggle bookmarking mode.

=item * Second Side Button

Select a bookmark or context menu item.  All of the drop-down menus will
subsequently close, and focus will be redirected back to the bookmarks bar for
continued navigation.

The user should avoid using this button to descend into a folder, as it will
induce unwanted behavior.  Use the right mouse button instead.

=item * Mouse Wheel Up

Moves B<left> in horizontal scrolling mode, up otherwise.

=item * Mouse Wheel down

Moves B<right> in horizontal scrolling mode, down otherwise.

=back

=head1 COMPATIBILITY

Some keybindings are not supported on all web browsers.  The following table
shows the commands which are not fully supported.  An asterisk indicates that
the command is partially supported with some limitation.

 +--------+--------+-------+---------+-------+
 | Cmds   | Chrome | Edge  | Firefox | Opera |
 +--------+--------+-------+---------+-------+
 | x      | yes    | yes   | yes     | no    |
 | y      | yes    | yes   | yes     | no    |
 | p      | yes    | yes   | yes     | no    |
 | a      | yes    | yes*  | yes     | yes*  |
 | A      | yes    | yes   | yes     | yes*  |
 | *      | yes    | yes   | no      | yes*  |
 +--------+--------+-------+---------+-------+

The remaining subsections discuss specific browsers.

=head2 Google Chrome

It's the browser used by the developer of this program (me), so it has the best
support.

=head2 Microsoft Edge

Microsoft Edge also works well with this program.

=head3 Command Limitations

The lowercase add command violates the desired behavior that was outlined for it
in its documentation.  Instead of adding a bookmark near the currently selected
item, it adds the bookmark at the end of the current folder.

=head2 Mozilla Firefox

The behavior of this program is fragile and buggy on Firefox.  You can expect to
encounter issues.

=head3 Command Limitations

The bookmarks bar is "locked down" comparative to other browsers.  On other
browsers, you can use the down arrow (j) on a folder on the bookmarks bar to
spawn a drop-down menu.  On Firefox however, you have to initially use the enter
key.

=head2 Opera and Opera GX

This program has periodically caused Opera to crash.

Unlike other web browsers, the standard cut, copy, and paste items do not appear
in Opera's bookmark context menus, which has made it impossible to implement the
C<x>, C<y>, and C<p> commands.

=head3 Command Limitations

The commands C<a> and C<A> only work when a folder is selected.  An error beep
will be heard if they are used over a bookmark.

The asterisk command C<*> does not open the bookmark manager to the item on
which it was used.  Instead, it opens to the root bookmark directory.

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

The positioning of the mouse can disrupt focus and consequently cause the script
to function improperly.  Make sure the mouse is not near the bookmark bar or any
pop-up menus when using a keybinding.  In bookmarking mode, the mouse is
outright disabled and even moved out of the way.  (Don't worry, its position is
later restored.)

=item

Web browsers are constantly changing.  New features are introduced all the time.
Context menus sometimes change, and UI components move around.  This requires me
to periodically update this script to adapt to a change.  Make sure you are
using the most up-to-date version of your browser and the most up-to-date
version of this script.  I use this script daily, so I am likely to stay on top
of changes, at least for my primary browser.

=item

I have personally verified this script to work with I<fresh installations> of
supported web browsers.  If you customize your web browser, e.g., by adding,
removing, or rearranging toolbar buttons, then you may introduce some breaking
change.

=back

=head1 TROUBLESHOOTING

Here are some common problems I run into and how to solve them.

=over

=item focus does not return to the bookmarks bar after an operation

Most operations are intended to preserve focus on the bookmarks bar so that the
user can continue to work from bookmark mode.  However, sometimes focus is lost
after performing an operation.  What's more, sometimes the focal element ends up
some place crazy.

Usually exiting and re-entering bookmark mode is enough to fix these kind of
issues.  You can always click on the web page to re-establish a known point of
focus.  If your browser has an easy keyboard shortcut to refocus the bookmarks
bar, use that.  For example, Chrome and Edge have C<CTRL+ALT+B>.

=item accidental deletion

If you accidentally delete something important, C<CTRL+Z> won't work unless
you're in the bookmark manager.  To recover a deleted item or to otherwise undo
an action, leave bookmarking mode, open the bookmark manager, and press
C<CTRL+Z> as many times as required.

=item synchronization

When the C</BAR:DYNAMIC> flag is passed on the command line, the bookmarks bar
toggles on and off when entering and exiting bookmark mode.  This process can
fall out of sync, i.e., the bar closes when opening the mode and vice versa. To
fix this, use a shortcut like C<CTRL+SHIFT+B> to show or hide the bar, bringing
it back into sync.  If your browser does not have an easy shortcut like this,
exit bookmark mode and look for the option to toggle visibility in the browser
settings.

=back

=head1 COMPILATION

This section contains instructions on how to compile this program.

=over

=item 1) Download the AutoHotkey compiler from GitHub.

=over

=item a) Go to L<https://github.com/AutoHotkey/Ahk2Exe>.

=item b) Click on the releases link.

=item c) Download the first zip file under the asset section.

=item d) Uzip it and take note of the C<Ahk2Exe.exe> file.

=back

=item 2) Download the AutoHotkey base image from GitHub.

=over

=item a) Go to L<https://github.com/AutoHotkey/AutoHotkey>.

=item b) Click on the releases link.

=item c) Download the first zip file under the asset section.

=item d) Unzip it and take note of the C<AutoHotkey64.exe> file.
You can delete the other files as they are not needed.

=back

=item 3) Download the dependency for this script from GitHub.

=over

=item a) Go to L<https://github.com/Descolada/UIA-v2>.

=item b) Clink on the releases link.

=item c) Download the first zip file under the asset section.

=item d) Unzip it and retrieve the file named C<UIA.ahk> in the C<Lib> folder.
You can delete the other files as they are not needed.

=back

=item 4) Download the source code for this script from GitHub.

=over

=item a) Go to L<https://github.com/zachary-krepelka/bookmarks>.

=item b) Open the C<user-interface> folder.

=item c) Click on the file named C<bookmark-motions.ahk>.

=item d) Click the download button.
It's on the right side amid a row of other buttons.

=back

=item 5) Optionally, download an icon for this program.

It must have the C<.ico> extension.  Try googling "free icons".  Use an online
icon converter to obtain the C<.ico> filetype if you chose a PNG, SVG, or
something else.  For the sake of this tutorial, let's assume that you named the
file C<bookmark-motions.ico>.

My personal solution involves running a shell script on WSL.

 1 #!/bin/sh
 2 wget https://raw.githubusercontent.com/microsoft/fluentui-system-icons/main/assets/Bookmark/SVG/ic_fluent_bookmark_32_filled.svg
 3 convert -background none ic_fluent_bookmark_32_filled.svg bookmark-motions.ico
 4 rm ic_fluent_bookmark_32_filled.svg

=item 6) Assemble all relevant files into a common folder.  You will need

=over

=item a) Ahk2Exe.exe

=item b) AutoHotkey64.exe

=item c) UIA.ahk

=item d) bookmark-motions.ahk

=item e) optionally an icon file

=back

=item 7) Compile the program.

Open the Windows Command Prompt and change to the directory where the files were
assembled in the previous step.  Now it only suffices to run the following
command.  You can exclude the C</icon> flag and its argument if you chose not to
use an icon.

 Ahk2Exe.exe /base AutoHotkey64.exe
             /in bookmark-motions.ahk
             /out bookmark-motions.exe
             /icon bookmark-motions.ico

This will produce a file called C<bookmark-motions.exe>.  You can feel free to
move it to a more permanent location.  It is a standalone executable.

=item 8) Prevent Windows from deleting the executable.

Microsoft Defender will think that the executable is a virus and attempt to
delete it.  Before running the program, the user will need to prevent this.  To
do so, follow these steps.

=over

=item a) Open the Windows Security application by searching for it.

=item b) Select "Virus & threat protection".

=item c) Click "Manage settings".

=item d) Scroll to the bottom and click "Add or remove exclusions".

=item e) Click "Yes" when prompted.

=item f) Click the "Add an exclusion" button.

=item g) Select "File" in the drop-down menu.

=item h) Locate C<bookmark-motions.exe> in the file dialog.

=item i) Click the "Open" button.

=item j) Close the Windows Security application.

=back

=item 9) Clean up.  You can delete all of the intermediate files.

=back

That's all!

Try C<bookmark-motions.exe /?> on the command-line to get started.

It is easy to automate the compilation process using a shell script on WSL.  You
can use a combination of C<wget> to download files, C<unzip> to extract zip
archives, and C<rm> for cleanup.

As an aside, AutoHotkey is an interpreted programming language.  In the
AutoHotkey world, compiling a program means to package that program with the
AutoHotkey interpreter into a standalone executable.  You could run this script
on your computer without compiling it, but that would require the user to
install the interpreter.

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

Port this program to Linux.  Maintain both versions.  I have decided to use the
AHK_X11 project.  This means that the port will only run on Linux machines using
the X window system.  I have already implemented the core functionality for
Google Chrome.

L<https://github.com/phil294/AHK_X11>

=item *

Use the C<UIA.ahk> library to probe and normalize the bookmarks bar so that this
program does not rest on assumptions about its initial state.  When the
bookmarks bar is static (C</BAR:STATIC>), ensure that it's visible before
entering bookmark mode.  When the bookmarks bar is dynamic (C</BAR:DYNAMIC>),
ensure that it's hidden before entering bookmark mode.

=item *

The C<UIA.ahk> library should also make it possible to improve the find command
C<f{char}>.  The following issues stand to be fixed.

=over

=item -

C<f{char}> does not work on the bookmarks bar.

=item -

When there is only one item beginning with C<{char}> in a drop-down menu,
navigating to that item with C<f{char}> will automatically open the targeted
item, which is undesirable because the user didn't expressively instruct it to
be opened.  This could possibly be addressed now that I have discovered this
library.

=item -

The backwards find command C<F{char}> also stands to be implemented.  It was
previously unfeasible to do before I discovered this library.

=back

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=head1 HISTORY

=over

=item v0.1.0 2024-03-08

=over

=item development begins

=back

=item v1.0.0 2025-10-08

=over

=item initial release

=back

=back

=cut

*/

; vim: tw=80 ts=8 sw=8 noet fdm=marker
