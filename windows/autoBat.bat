@echo off
set curDir=%cd%
cd /d D:\Jenkins\workspace\batch_daily\software\proj_highrail
python main_ph.py
set res=%errorlevel%
cd /d %curDir%
echo %errorlevel%
@echo on
exit /B %res%