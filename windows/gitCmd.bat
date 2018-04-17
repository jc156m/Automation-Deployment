@echo off
set curDir=%cd%
if "%1"=="" (
echo "aaa"
exit 1
)
cd /d %1
git commit -am "ver add %2"
git push origin master
cd /d %curDir%
@echo on