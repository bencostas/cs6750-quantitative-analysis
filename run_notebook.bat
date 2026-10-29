@echo off
setlocal
cd /d "%~dp0"

py -3.13 --version >nul 2>&1
if errorlevel 1 (
    echo This project needs Python 3.13. Python 3.15 is too new for one of the dependencies.
    echo Install Python 3.13 from https://www.python.org/downloads/ and then run this file again.
    pause
    exit /b 1
)

if exist ".venv\Scripts\python.exe" (
    ".venv\Scripts\python.exe" -c "import sys; raise SystemExit(sys.version_info[:2] != (3, 13))" >nul 2>&1
    if errorlevel 1 (
        echo Replacing the existing environment with Python 3.13...
        rmdir /s /q ".venv"
    )
)

if not exist ".venv\Scripts\python.exe" (
    py -3.13 -m venv .venv
    if errorlevel 1 (
        echo Failed to create the Python 3.13 virtual environment.
        pause
        exit /b 1
    )
)

".venv\Scripts\python.exe" -c "import sys; raise SystemExit(sys.version_info[:2] != (3, 13))" >nul 2>&1
if errorlevel 1 (
    echo The .venv environment is not running Python 3.13.
    pause
    exit /b 1
)

if exist ".venv-3.13" (
    echo Removing the duplicate .venv-3.13 environment...
    rmdir /s /q ".venv-3.13"
)

".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo Failed to install dependencies.
    pause
    exit /b 1
)

".venv\Scripts\python.exe" -m notebook quantitative_analysis.ipynb
if errorlevel 1 (
    echo Failed to launch the notebook.
    pause
    exit /b 1
)
