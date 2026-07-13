@echo off
setlocal
cd /d "%~dp0"

where py >nul 2>nul
if %errorlevel%==0 (
    set "PY=py -3"
) else (
    where python >nul 2>nul
    if errorlevel 1 (
        echo Python was not found.
        echo Install 64-bit Python 3.10 or newer from https://www.python.org/
        echo Make sure "Add Python to PATH" is selected.
        pause
        exit /b 1
    )
    set "PY=python"
)

%PY% -c "import numpy" >nul 2>nul
if errorlevel 1 (
    echo Installing the NumPy native Turbo engine for fast expansion...
    %PY% -m pip install --user "numpy>=1.24"
    if errorlevel 1 (
        echo WARNING: NumPy installation failed. The merger will use its slower scalar fallback.
        timeout /t 3 >nul
    )
)

%PY% "%~dp0flp_note_merger.py"
if errorlevel 1 pause
endlocal
