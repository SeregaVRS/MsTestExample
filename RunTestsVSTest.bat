:: set the location of vstest.console.exe - it could be in a few different locations
:: E.g. c:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe

@ECHO OFF
@SET TEST_RUNNER_EXE_NAME=vstest.console.exe
@SET TEST_RUNNER_VERSIONS=" 10.0" " 11.0" " 12.0" " 14.0" "\2017\Professional" "\2017\TestAgent" "\2017\Enterprise" "\2017\Community"
@SET TEST_RUNNER_PATH_PREFIX=%PROGRAMFILES(x86)%\Microsoft Visual Studio
@SET TEST_RUNNER_PATH_POSTFIX=Common7\IDE\CommonExtensions\Microsoft\TestWindow\%TEST_RUNNER_EXE_NAME%

:: Try to find necessary version of vstest.console.exe
@FOR %%v IN (%TEST_RUNNER_VERSIONS%) DO (
  @for /f "delims=" %%a in (%%v) do (
    @IF EXIST "%TEST_RUNNER_PATH_PREFIX%%%~a\%TEST_RUNNER_PATH_POSTFIX%" (
	@SET VSTEST_LOCATION="%TEST_RUNNER_PATH_PREFIX%%%~a\%TEST_RUNNER_PATH_POSTFIX%"
	)
) 	
)

@ECHO %VSTEST_LOCATION%
call %VSTEST_LOCATION% d:\Projects\MsTestExample\MsTestExample\MsTestExample\bin\Release\MsTestExample.dll /Logger:trx
pause