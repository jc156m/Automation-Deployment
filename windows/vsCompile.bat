@echo off
cls

::先判断是否存在LOG目录，不存在则创建
if not exist log md log

set ret=0
set _log="%~dp0log\compileResults_%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.log"
set VCEmv=VC\bin\vcvars32.bat
set VSPath=C:\Program Files (x86)\Microsoft Visual Studio 11.0\
for /f "skip=1  tokens=1,2,*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "11.0"') do ( 
if not "%%k"=="" set VSPath=%%k%VCEmv%
)

if "%1"=="" (
echo >>%_log%
exit 1
)
echo %_log%
echo %VSPath%
call "%VSPath%"
echo [%DATE% %Time%] Start compile sequence >>%_log%
set _solution_file=%1
echo %_solution_file% >>%_log%
::MSBuild %_solution_file% /t:Rebuild /p:Configuration=Release  /p:Platform="Win32"

::devenv.com %_solution_file% /Rebuild "Release|Win32" /Out %_log%
::联合编译
BuildConsole.exe %_solution_file% /prj="*" /rebuild /All /Log=%_log% /cfg="Release|Win32"

if %errorlevel% == 0 (
echo %_solution_file% compiled successful >>%_log%
)else (
echo %_solution_file% failed!   Error: %errorlevel% >>%_log%
 set ret=%errorlevel%
)
echo [%DATE% %Time%] Finished compile sequence >>%_log%

if %ret% == 0 (
::拷贝编译日志到上级目录
copy /y %_log% %~dp0build.log
)else (
exit 2
)