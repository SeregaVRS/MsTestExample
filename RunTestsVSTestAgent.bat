:: set the location of vstest.console.exe after TestAgent Install
:: https://docs.microsoft.com/en-us/visualstudio/test/lab-management/install-configure-test-agents
:: E.g. C:\Program Files (x86)\Microsoft Visual Studio\2017\TestAgent\Common7\IDE\CommonExtensions\Microsoft\TestWindow

@ECHO OFF
@SET VSTEST_LOCATION="%PROGRAMFILES(x86)%\Microsoft Visual Studio\2017\TestAgent\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe"

@ECHO %VSTEST_LOCATION%
call %VSTEST_LOCATION% d:\Projects\MsTestExample\MsTestExample\MsTestExample\bin\Release\MsTestExample.dll /Logger:trx

pause