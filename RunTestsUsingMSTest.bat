:: set the location of mstest - it could be in a few different locations
:: the default (initial) location is for WinXP machines
:: E.g. 
@ECHO OFF
@SET TEST_RUNNER_EXE_NAME=mstest.exe
@SET TEST_RUNNER_VERSIONS=" 10.0" " 11.0" " 12.0" " 14.0" "\2017\Professional" "\2017\TestAgent" "\2017\Enterprise" "\2017\Community"
@SET TEST_RUNNER_PATH_PREFIX=%PROGRAMFILES(x86)%\Microsoft Visual Studio
@SET TEST_RUNNER_PATH_POSTFIX=Common7\IDE\%TEST_RUNNER_EXE_NAME%
@FOR %%v IN (%TEST_RUNNER_VERSIONS%) DO (
  @for /f "delims=" %%a in (%%v) do (
    @IF EXIST "%TEST_RUNNER_PATH_PREFIX%%%~a\%TEST_RUNNER_PATH_POSTFIX%" (
	@SET MSTEST_LOCATION="%TEST_RUNNER_PATH_PREFIX%%%~a\%TEST_RUNNER_PATH_POSTFIX%"
	)
) 	
)
@ECHO %MSTEST_LOCATION%
pause