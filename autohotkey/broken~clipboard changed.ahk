;
;  This helped me download notes from any type of window, by selecting. 
;  Milliseconds later, a traytip and "fileappend" (interface?)
;
;  Didn't do backups... but the pausing no longer toggles either.
; 
;  Originally kept adding the same the same lines, specifically a bug, when the cursor left focus of the window
;  Then I made the active_wnd check, tried to expand, then nothing works, and I toggled every if, adjusted every SleepTimer. 
;
;   AHK sometimes.... It was perfect, then, it broke when I most needed it.
;


;#Persistent
#SingleInstance

#InstallMouseHook
;#InstallKeybdHook
;SendMode Input
AutoTrim off 

return

;Suspend Permit

;%A_IsPaused% = false
;;global app_new_class = ;

;MsgBox, , "Running?", %running%
;MsgBox, , "WriteOut?", %write_out%


;Main:
;TrayTip, "TextLogging off", "Press Ctrl+PrintScreen to enable it\n" += "Script can be suspended with Win+ScrollLock" , 3000
;return

UnFrozen:

	^Escape:: Reload

	#ScrollLock:: InvertPause()

InvertPause() 
{
		if ( A_IsPaused ) {
			Pause Toggle
			TrayTip, "Status", "Resumed", 500

		}
		Else Pause Toggle
		return
}
	

	^PrintScreen:: SwitchLogFile()
		




SwitchLogFile()
{
		writer_state = write_out
		if (writer_state == 1) {
			write_out = 1
			TrayTip, "Text Logging Enabled", "In file " += %A_Desktop%\log3.txt", 1000
		}
		else {
			write_out = 0
			TrayTip, "Text Logging SUSPENDED", "In file " += %A_Desktop%\log3.txt", 1000
		}	
return
}

; never ---V

TheLoop:
	if ( A_IsPaused is false ) { 
		TrayTip,  , "Bullshit", 10000
		Sleep, 300 
		gosub UnFrozen
	}
return
	; BACK TO INPUT IF PAUSED ;

WaitForIt:
	WinGetClass, app_old_class
	
	tempclip = %Clipboard%
	;temp2 = ; ---> mistake
			/**** OPTIONAL ****/
			;SetMouseDelay, 200 
			;SetKeyDelay, 10, 5

	KeyWait, ~LButton, Up::
				; To avoid copying the same buffer from the same window
				; from the mouse entering and leaving the space...
			WinGetClass, app_new_class
			If (app_new_class != app_old_class) Goto WaitForIt
				; set this blank here to make sure clipboard has changed
				
			temp2 =  ;

			Send, ^c
			;Sleep, 200
				
			ClipWait, , 1
			temp2 = %Clipboard%
				
			if (tempclip == temp2) 
				{ 	
					Sleep 300		; take a pause
					goto WaitForIt, 
				}


			else 
			{
				Sleep 200
				goto OnClipboardChange
			}
		
			;return ; lbutton end never reached	
;why nplyt???
		OnClipboardChange:
		;Sleep 1000c
			TrayTip, "copying", %temp2%, 300
			if ( write_out == 1 ) FileAppend, %temp2%, %A_Desktop%\log2.txt
			Sleep 750
			Gosub, WaitForIt
		
return ; never reached
