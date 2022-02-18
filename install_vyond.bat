:: Vyond Legacy Offline Installer
:: Author: joseph the animator#2292
:: License: MIT
title Vyond Legacy Offline Installer [Initializing...]

::::::::::::::::::::
:: Initialization ::
::::::::::::::::::::

:: Stop commands from spamming stuff, cleans up the screen
@echo off && cls

:: Lets variables work or something idk im not a nerd
SETLOCAL ENABLEDELAYEDEXPANSION

:: Make sure we're starting in the correct folder, and that it worked (otherwise things would go horribly wrong)
pushd "%~dp0"

:: Check *again* because it seems like sometimes it doesn't go into dp0 the first time???
pushd "%~dp0"

::::::::::::::::::::::
:: Dependency Check ::
::::::::::::::::::::::

title Vyond Legacy Offline Installer [Checking for Git...]
echo Checking for Git installation...

:: Preload variables
set GIT_DETECTED=n

:: Git check
for /f "delims=" %%i in ('git --version 2^>nul') do set output=%%i
IF "!output!" EQU "" (
	echo Git could not be found.
) else (
	echo Git is installed.
	echo:
	set GIT_DETECTED=y
)
popd

::::::::::::::::::::::::
:: Dependency Install ::
::::::::::::::::::::::::

if !GIT_DETECTED!==n (
	title Vyond Legacy Offline Installer [Installing Git...]
	echo:
	echo Installing Git...
	echo:
	fsutil dirty query !systemdrive! >NUL 2>&1
	if /i not !ERRORLEVEL!==0 (
		color cf
		cls
		echo:
		echo ERROR
		echo:
		echo Vyond Legacy Offline needs to install Git.
		echo To do this, the installer must be started with Admin rights.
		echo:
		echo Close this window and re-open the installer as an Admin.
		echo ^(right-click install_vyond.bat and click "Run as Administrator"^)
		pause
		exit
		)
	)
)
:postadmincheck

if !GIT_DETECTED!==n (
	:: Install Git
	if not exist "git_installer.exe" (
		echo We have a problem. The Git installer doesn't exist.
		echo A normal copy of the Vyond Legacy Offline installer
		echo should come with one.
		echo You should be able to find a copy on this website:
		echo https://git-scm.com/downloads
		pause & exit
	)
	echo Proper Git installation doesn't seem possible to do automatically.
	echo You can just keep clicking next until it finishes,
	echo and the Vyond installer will continue once it closes.
	git_installer.exe
	goto git_installed
	
	:git_installed
	echo Git has been installed.
	set GIT_DETECTED=y
)

:: Alert user to restart the installer without running as Admin
if !ADMINREQUIRED!==y (
	color 20
	cls
	echo:
	echo Vyond Legacy Offline no longer needs Admin rights,
	echo please restart normally by double-clicking.
	echo:
	pause
	exit
)

:::::::::::::::::::::::::
:: Post-Initialization ::
:::::::::::::::::::::::::

title Vyond Legacy Offline Installer
:cls
cls

echo Vyond Legacy Offline Installer
echo Project lead by Fanimation36. Installer is created by Joseph Animate 2021.
echo:
echo Enter 1 to install Vyond Legacy Offline
echo Enter 0 to close the installer
:wrapperidle
echo:

:::::::::::::
:: Choices ::
:::::::::::::

set /p CHOICE=Choice:
if "!choice!"=="0" goto exit
if "!choice!"=="1" goto download
echo Time to choose. && goto wrapperidle

:download
cls
pushd "%~dp0..\..\"
echo Cloning repository from GitHub...
git clone https://github.com/josephcrosmanplays532/Vyond-Legacy-Offline.git
cls
echo Vyond Legacy Offline has been installed^^!
echo Feel free to move it wherever you want.
start "" "%~dp0..\..\Vyond-Legacy-Offline"
goto exit

:exit
pause & exit
