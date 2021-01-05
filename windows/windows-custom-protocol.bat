@echo off
setlocal EnableDelayedExpansion
mode con: cols=101 lines=30

echo                                          [96;1m#########################################################
echo           [91;1m,.=:llt3Z3z.,                  [96;1m##      .oPYo.                 o                       ##
echo          [91;1m:tt:::tt333EE3                  [96;1m##      8    8                 8                       ##
echo          [91;1mEt:::ztt33EEEL[92;1m @Ee.,      ..,   [96;1m##      8      o    o .oPYo.  o8P .oPYo. ooYoYo.       ##
echo         [91;1m;tt:::tt333EE7[92;1m ;EEEEEEttttt33#   [96;1m##      8      8    8 Yb..     8  8    8 8' 8  8       ##
echo        [91;1m:Et:::zt333EEQ.[92;1m $EEEEEttttt33QL   [96;1m##      8    8 8    8   'Yb.   8  8    8 8  8  8       ##
echo        [91;1mit::::tt333EEF[92;1m @EEEEEEttttt33F    [96;1m##      `YooP' `YooP' `YooP'   8  `YooP' 8  8  8       ##
echo       [91;1m;3=*^```"*4EEV[92;1m :EEEEEEttttt33@.     [96;1m##      :.....::.....::.....:::..::.....:..:..:..      ##
echo       [94;1m,.=::::lt=., [91;1m`[92;1m @EEEEEEtttz33QF     [96;1m##      :::::::::::::::::::::::::::::::::::::::::      ##
echo      [94;1m;::::::::zt33)[92;1m   "4EEEtttji3P*      [96;1m##   .oPYo.                o                       8   ##
echo     [94;1m:t::::::::tt33.[93;1m:Z3z..[92;1m  ``[93;1m ,..g.      [96;1m##   8    8                8                       8   ##
echo     [94;1mi::::::::zt33F[93;1m AEEEtttt::::ztF       [96;1m##  o8YooP' oPYo. .oPYo.  o8P .oPYo. .oPYo. .oPYo. 8   ##
echo    [94;1m;:::::::::t33V[93;1m ;EEEttttt::::t3        [96;1m##   8      8  `' 8    8   8  8    8 8    ' 8    8 8   ##
echo    [94;1mE::::::::zt33L[93;1m @EEEtttt::::z3F        [96;1m##   8      8     8    8   8  8    8 8    . 8    8 8   ##
echo   [94;1m{3=*^```"*4E3)[93;1m ;EEEtttt:::::tZ`         [96;1m##   8      8     `YooP'   8  `YooP' `YooP' `YooP' 8   ##
echo              [94;1m`[93;1m :EEEEtttt::::z7           [96;1m##  :..:::::..:::::.....:::..::.....::.....::.....:..  ##
echo                  [93;1m"VEzjt:;;z>*`           [96;1m##  :::::::::::::::::::::::::::::::::::::::::::::::::  ##
echo                                          [96;1m#########################################################[0m
echo.
:restart

echo.
SET /P protocolName=What scheme should your protocol use ( type myProtocol for a "myProtocol:..." scheme ) ? 
echo.
set /P isAdmin=Do you have Admin rights ? Yes (Y) No (N) ? 
set protocolKeyPath=HKEY_CLASSES_ROOT\
if /I "!isAdmin!" EQU "N" set protocolKeyPath=HKEY_CURRENT_USER\Software\Classes\
set openScriptName=open-local-file.js
(
echo Windows Registry Editor Version 5.00
echo [!protocolKeyPath!!protocolName!]
echo "URL Protocol"=""
echo @="URL:%protocolName% protocol"
echo [!protocolKeyPath!!protocolName!\shell]
echo [!protocolKeyPath!!protocolName!\shell\open]
echo [!protocolKeyPath!!protocolName!\shell\open\command]
echo @="\"C:\\Windows\\System32\\wscript.exe\" \"C:\\customProtocols\\!openScriptName!\" \"%%1\""
) > %protocolName%ProtocolKey.reg

%protocolName%ProtocolKey.reg

if %errorlevel% EQU 0 (
    echo.
    echo [0;92;1m[############################################## [OK] ##############################################][0m
) else (
	echo [0;91;1m[############################################## [KO] ##############################################][0m
    set choice=
    set /p choice=Do you want to Quit ^(Q^), Restart ^(R^) or Continue anyway ^(Any Key^) ? 
    if "!choice!" EQU "Q" goto:restartOrQuit
    if "!choice!" EQU "R" goto:restartOrQuit
)

if /I "!isAdmin!" EQU "N" goto noCheckBox

pause>nul|set/p =Importing registry key to display the "Remember" checkbox. Press Any key to continue ...

(
echo Windows Registry Editor Version 5.00
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
echo "ExternalProtocolDialogShowAlwaysOpenCheckbox"=dword:00000001
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome]
echo "ExternalProtocolDialogShowAlwaysOpenCheckbox"=dword:00000001
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Chromium]
echo "ExternalProtocolDialogShowAlwaysOpenCheckbox"=dword:00000001
) > ShowExternalProtocolWarningBypassCheckbox.reg
ShowExternalProtocolWarningBypassCheckbox.reg
if %errorlevel% EQU 0 (
    echo.
    echo [0;92;1m[############################################## [OK] ##############################################][0m
) else (
	echo [0;91;1m[############################################## [KO] ##############################################][0m
    set choice=
    set /p choice=Do you want to Quit ^(Q^), Restart ^(R^) or Continue anyway ^(Any Key^) ? 
    if "!choice!" EQU "Q" goto:restartOrQuit
    if "!choice!" EQU "R" goto:restartOrQuit
)

goto endNoCheckBox

:noCheckBox
pause>nul|set/p =[0;95;1mCannot authorize the "Remember" checkbox without admin rights. Press Any key to continue ...[0m
echo.
:endNoCheckBox

pause>nul|set/p =Copying script to open files ^(c:\customProtocols\!openScriptName!^). Press Any key to continue ...

if not exist "c:\customProtocols" (
	mkdir c:\customProtocols
)

(
echo var filePath = decodeURIComponent^( WScript.arguments^(0^).substring^(WScript.arguments^(0^).indexOf^(':'^)+1^) ^).replace^(/\//g, '\\'^);
echo var shell = WScript.CreateObject^("WScript.Shell"^);
echo var fileSystem = new ActiveXObject^("Scripting.FileSystemObject"^);
echo try{
echo     if^( ^^!fileSystem.FolderExists^(filePath^) ^&^& ^^!fileSystem.FileExists^(filePath^) ^){
echo         throw "Folder or file not found : \n" + filePath;
echo     }
echo     shell.Run^( "explorer.exe " + filePath ^);
echo }catch^(error^){
echo      shell.Popup^( error , 0, "Error : Cannot Open" ^);
echo }
echo WScript.Quit^(0^);
) > c:\customProtocols\!openScriptName!

if exist "c:\customProtocols\!openScriptName!" (
    echo.
    echo [0;92;1m[############################################## [OK] ##############################################][0m
) else (
	echo [0;91;1m[############################################## [KO] ##############################################][0m
    set choice=
    set /p choice=Do you want to Quit ^(Q^), Restart ^(R^) or Continue anyway ^(Any Key^) ? 
    if "!choice!" EQU "Q" goto:restartOrQuit
    if "!choice!" EQU "R" goto:restartOrQuit
)
echo.

set /P TEST=Would you like to try your protocol in a browser ?  Yes (Y) No (N) : 
if /I "!TEST!" NEQ "Y" goto testEnd
echo [0;95;1mWarning : Test the link before you proceed to temporary files deletion.[0m
(
echo Local text file.
echo If clicking the link brought you here wihtout downloading the file, your new protocol should be working.
echo Please continue the script execution to delete temporary files.
) > testFile.txt 

(
echo ^<a href="!protocolName!:%cd%\testFile.txt"^>Test Link^</a^>
) > testProtocol.html

echo "%cd%\testProtocol.html"

explorer "%cd%\testProtocol.html"

:testEnd

goto deleteTempFiles

:restartOrQuit
if "!choice!"=="R" (
    echo.
    echo [0;96;1m[########################################## [RESTARTING] ##########################################][0m
    goto restart
)

:deleteTempFiles
pause>nul|set/p =Deleting temporary files. Press Any key to continue ...

if exist "testFile.txt" (
	del fichierTest.txt /f /q
)
if exist "testProtocol.html" (
	del testProtocol.html /f /q
)
if exist "!protocolName!ProtocolKey.reg" (
    del "!protocolName!ProtocolKey.reg" /f /q
)
if exist "ShowExternalProtocolWarningBypassCheckbox.reg" (
    del ShowExternalProtocolWarningBypassCheckbox.reg /f /q
)
echo.
echo [0;92;1m[############################################## [OK] ##############################################][0m

pause>nul|set/p =[0;96;1m[######################################### [END OF SETUP] #########################################][0m
