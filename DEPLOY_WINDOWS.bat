@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo SMART ATTENDANCE V8 - FIREBASE DEPLOY
echo ========================================
echo.

echo This script deploys the dashboard from:
echo   %CD%\dashboard

echo.

where firebase >nul 2>nul
if errorlevel 1 (
  echo ERROR: Firebase CLI is not installed or not in PATH.
  echo Install it with: npm install -g firebase-tools
  pause
  exit /b 1
)

echo Checking Firebase project...
firebase use --add
if errorlevel 1 (
  echo ERROR: Firebase project selection failed.
  pause
  exit /b 1
)

echo.
echo Deploying Hosting...
firebase deploy --only hosting
if errorlevel 1 (
  echo ERROR: Hosting deployment failed.
  pause
  exit /b 1
)

echo.
echo Deploying Realtime Database rules...
firebase deploy --only database
if errorlevel 1 (
  echo ERROR: Database rules deployment failed.
  pause
  exit /b 1
)

echo.
echo ========================================
echo DEPLOYMENT COMPLETE
echo ========================================
echo Open:
echo https://rfid-attendance-system-a2579.web.app
pause
