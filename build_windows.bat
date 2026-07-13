@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo  Building FLP Note Merger FAST Windows app folder
echo ============================================================

where py >nul 2>nul
if %errorlevel%==0 (
    set "PY=py -3"
) else (
    where python >nul 2>nul
    if errorlevel 1 (
        echo ERROR: Python was not found.
        echo Install 64-bit Python 3.10 or newer from https://www.python.org/
        pause
        exit /b 1
    )
    set "PY=python"
)

%PY% -m pip install --user --upgrade pyinstaller "numpy>=1.24"
if errorlevel 1 goto :failed

if exist "%~dp0release\FLP_Note_Merger" rmdir /s /q "%~dp0release\FLP_Note_Merger"

rem ONEDIR intentionally starts much faster than ONEFILE because the large
rem NumPy native runtime does not need to unpack into %%TEMP%% on every launch.
%PY% -m PyInstaller ^
  --noconfirm ^
  --clean ^
  --onedir ^
  --noupx ^
  --windowed ^
  --name FLP_Note_Merger ^
  --distpath "%~dp0release" ^
  --workpath "%TEMP%\FLP_Note_Merger_build" ^
  "%~dp0flp_note_merger.py"
if errorlevel 1 goto :failed

echo.
echo Fast build complete:
echo   %~dp0release\FLP_Note_Merger\FLP_Note_Merger.exe
echo.
echo Keep the complete FLP_Note_Merger folder together when copying it.
echo.
pause
exit /b 0

:failed
echo.
echo ERROR: Build failed. Review the messages above.
pause
exit /b 1
