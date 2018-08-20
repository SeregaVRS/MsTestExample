:: set the location of vstest.console.exe after TestAgent Install
:: https://docs.microsoft.com/en-us/visualstudio/test/lab-management/install-configure-test-agents
:: E.g. Program Files (x86)\Microsoft Visual Studio\2017\TestAgent\Common7\IDE\MSTest.exe
:: E.g. Program Files (x86)\Microsoft Visual Studio\2017\TestAgent\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe

@ECHO OFF
@SET VSTEST_LOCATION="%PROGRAMFILES(x86)%\Microsoft Visual Studio\2017\TestAgent\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe"
@ECHO %VSTEST_LOCATION%

@SET TESTDLL_LOCATION=MsTestExample\MsTestExample\bin\Release\MsTestExample.dll
@ECHO %TESTDLL_LOCATION% 

@ECHO Run Tests...
call %VSTEST_LOCATION% %TESTDLL_LOCATION% /Logger:trx;

pause