@ECHO ON
@ECHO ---------------------------------------------------------
@ECHO STEP 1. Initialisation.
@ECHO STEP 1.1. Initialising script variables.

:: location of the DLLs and where to push the results to
@IF NOT DEFINED TEST_SOURCE_DIR SET TEST_SOURCE_DIR=\\cobalttesttools.int.westgroup.com\cobalttesttools$\QED\WLNR\SevenKingdoms\HouseTargaryen\TestFiles
@IF NOT DEFINED TEST_RESULT_ROOT_DIR SET TEST_RESULT_ROOT_DIR=\\cobalttesttools.int.westgroup.com\cobalttesttools$\QED\WLNR\%TEST_SUITE%\%TEST_ENVIRONMENT%\%TEST_BROWSER%

:: reporting variables
@SET EMAIL_FROM=QReport@thomsonreuters.com
@SET EMAIL_TO=%QREPORT_RESULTS_EMAIL%
@SET EMAIL_ERROR_TO=%QREPORT_RESULTS_EMAIL%
@SET QREPORT_SUBJECT=%TEST_SUITE%_%TEST_ENVIRONMENT%_%TEST_BROWSER%
@IF NOT DEFINED BUSINESS_CASE_NAME SET BUSINESS_CASE_NAME=Module Regression Testing

@SET TEST_RESULT_FILENAME=TestResults
@SET TEST_EXECUTION_DIR=C:\Temp\TestExecution
@SET SELENIUM_DRIVERS_DIR=C:\SeleniumDrivers
@SET TEST_SETTINGS_FILE_LOCATION=%TEST_EXECUTION_DIR%\Local.testsettings
@SET RUN_SETTINGS_FILE_LOCATION=%TEST_EXECUTION_DIR%\Local.runsettings
@SET HH=%time:~0,2%
@IF "%HH:~0,1%"==" " SET HH=0%HH:~1,1%
@SET TODAYS_DATETIME=%date:~10,4%-%date:~4,2%-%date:~7,2%_%HH%%time:~3,2%
@SET TEST_RESULT_DIR=%TEST_RESULT_ROOT_DIR%\%TODAYS_DATETIME%

:: set the location of the test Runner (VsTest.Console.exe)
@ECHO STEP 1.2. Initialising a test runner.
@GOTO BeginTestRunnerInitBlock

:EndTestRunnerInitBlock
@ECHO ---------------------------------------------------------
@ECHO STEP 2. Preparation.
@ECHO STEP 2.1. Preparing file system objects.

:: if the additional results folder is defined, set the directory
@IF DEFINED ADDITIONAL_RESULTS_FOLDER SET ADDITIONAL_RESULTS_DIR=%TEST_RESULT_DIR%\%ADDITIONAL_RESULTS_FOLDER%\

@IF EXIST "%TEST_EXECUTION_DIR%"\ RMDIR /S /Q "%TEST_EXECUTION_DIR%" & MKDIR "%TEST_EXECUTION_DIR%"

:: create additional results directory
@IF DEFINED ADDITIONAL_RESULTS_DIR IF NOT EXIST "%ADDITIONAL_RESULTS_DIR%"\ MKDIR "%ADDITIONAL_RESULTS_DIR%"\

:: copy regression tests locally
@ECHO STEP 2.2. Copying test artefacts to %COMPUTERNAME%:
robocopy "%TEST_SOURCE_DIR%" "%TEST_EXECUTION_DIR%" /s /njh /njs /ndl /nc /ns /np

:: Copying Selenium drivers to known location
@ECHO STEP 2.3. Copying browser drivers artefacts to "%SELENIUM_DRIVERS_DIR%" on %COMPUTERNAME%:
@SET DRIVERS_TO_COPY=chromedriver.exe IEDriverServer.exe geckodriver.exe MicrosoftWebDriver.exe
@IF NOT EXIST %SELENIUM_DRIVERS_DIR% MKDIR %SELENIUM_DRIVERS_DIR%
FOR %%x in (%DRIVERS_TO_COPY%) DO COPY /Y %TEST_EXECUTION_DIR%\Resources\DriverExecutables\%%x %SELENIUM_DRIVERS_DIR%\%%x

@ECHO STEP 2.4. Updating the content of the "%TEST_SETTINGS_FILE_LOCATION%" file:
@attrib -R "%TEST_SETTINGS_FILE_LOCATION%"
@CD "%TEST_EXECUTION_DIR%"
"%TEST_EXECUTION_DIR%"\TestSettingsUtility.exe "%TEST_SETTINGS_FILE_LOCATION%" "%TEST_SETTINGS_FILE_LOCATION%" "%QREPORT_SUBJECT%" 

@ECHO OFF
ECHO ---------------------------------------------------------
ECHO STEP 3. Execution.
GOTO BeginVerificationBeforLaunch

:EndVerificationBeforLaunch
:: execute the tests
ECHO STEP 3.1. Running automation tests from the "%TEST_CONTAINER%.dll" assembly:
SET TEST_RUN_COMMAND=%VSTEST_LOCATION% "%TEST_EXECUTION_DIR%\%TEST_CONTAINER%.dll" /Settings:"%RUN_SETTINGS_FILE_LOCATION%" /Logger:trx

IF NOT "%CATEGORY_NAME%" == "" SET TEST_RUN_COMMAND=%TEST_RUN_COMMAND% /TestCaseFilter:"%CATEGORY_NAME%"

PushD %TEST_EXECUTION_DIR%
%TEST_RUN_COMMAND%
RENAME *.trx %TEST_RESULT_FILENAME%.trx
MOVE %TEST_RESULT_FILENAME%.trx .
PopD

IF NOT EXIST "%TEST_EXECUTION_DIR%\%TEST_RESULT_FILENAME%.trx" (
  SET ERRORLEVEL=-1
  SET EXIT_MSG=ERROR: %TEST_RESULT_FILENAME%.trx was not found in %TEST_EXECUTION_DIR%. The test run might have failed or not started. 
  GOTO TerminateScriptBlock
)

@ECHO ON
@ECHO ---------------------------------------------------------
@ECHO STEP 4. Test Result Reporting.
:: copy the results to a network location
@ECHO STEP 4.1. Copying the results to NAS drive:
@IF NOT EXIST "%TEST_RESULT_DIR%"\ MKDIR "%TEST_RESULT_DIR%"
COPY /y "%TEST_EXECUTION_DIR%\*.trx" "%TEST_RESULT_DIR%\*.trx"
COPY /y "%TEST_EXECUTION_DIR%\%TEST_SUITE%_%TEST_ENVIRONMENT%_%TEST_BROWSER%\Out\QualityTestRun.xml" "%TEST_RESULT_DIR%\QualityTestRun.xml"
robocopy "%TEST_EXECUTION_DIR%" "%TEST_RESULT_DIR%" "*config.xml" "*.jpg" /XD In /s /njh /njs /ndl /nc /ns /np

:: copy additional results to network location
@IF DEFINED ADDITIONAL_RESULTS_DIR robocopy "%TEST_EXECUTION_DIR%\%ADDITIONAL_RESULTS_FOLDER%" "%ADDITIONAL_RESULTS_DIR%" /s

@ECHO STEP 4.2. Preparing a QRT2.0 report:
@SET RESULT_FILE_TYPE=MSUnit

@IF NOT DEFINED QRT2_LOAD_EMAIL SET QRT2_LOAD_EMAIL=%QRT_RESULTS_EMAIL%

@SET QRT2_TEST_CONFIG_PATH="%TEST_RESULT_DIR%"\Qrt2TestConfig.xml
@SET QRT2_CONSOLE_DIR=\\cobalttesttools.int.westgroup.com\cobalttesttools$\QED\QedArsenal\QRTConsole\Application
@SET QRT2_QUALITY_TEST_RUN_PATH=%TEST_RESULT_DIR%\QualityTestRun.xml

@MD %TEST_EXECUTION_DIR%\QRT2Console

:: copy down qrtconsole.exe to local machine
COPY /y "%QRT2_CONSOLE_DIR%"\*.* "%TEST_EXECUTION_DIR%"\QRT2Console
:: execute the test results load into QRT
"%TEST_EXECUTION_DIR%\QRT2Console\QRT.Console.exe" "%RESULT_FILE_TYPE%" "%QRT2_TEST_CONFIG_PATH%" "%TEST_RESULT_DIR%\%TEST_RESULT_FILENAME%.trx" %QRT2_LOAD_EMAIL% -q "%QRT2_QUALITY_TEST_RUN_PATH%" -l

:: check whether QReport should be used for reporting
@IF NOT DEFINED SUPPRESS_QREPORT GOTO CleanUpScriptBlock
@IF /I NOT "%SUPPRESS_QREPORT%"=="NO" GOTO CleanUpScriptBlock
@ECHO STEP 4.3. Preparing a QReport test results report:
@GOTO BeginGenerateQReport

:CleanUpScriptBlock
@ECHO ---------------------------------------------------------
@ECHO STEP 5. Termintation.
:: kill Chrome, Chrome driver, Firefox, IE and IE driver after running the test
@ECHO STEP 5.1. Terminating browser and Web Driver processes, if they are still running
@SET PROC2KILL=chrome.exe chromedriver.exe firefox.exe iexplore.exe IEDriverServer.exe geckodriver.exe
FOR %%x in (%PROC2KILL%) DO TASKKILL /F /FI "STATUS ne UNKNOWN" /IM %%x

@ECHO STEP 5.2. Deleting any downloaded files:
@SET DOWNLOAD_DIR=%USERPROFILE%\Downloads
FOR %%p IN ("%DOWNLOAD_DIR%\*.*") DO DEL "%%p" /F /S /Q

@ECHO OFF
@ECHO STEP 5.3. Deleting any temp files created by webdrivers and browsers:
@SET CLEANUP_LOG_FILE="%TEST_EXECUTION_DIR%\cleanup.log"
CALL :CLEANUP "%temp%" "scoped_dir*"
if not %temp%==%tmp% CALL :CLEANUP "%tmp%" "scoped_dir*"
CALL :CLEANUP "%temp%" "IE*.tmp"
if not %temp%==%tmp% CALL :CLEANUP "%tmp%" "IE*.tmp"
@ECHO Clean up has been completed. 
IF EXIST %CLEANUP_LOG_FILE% COPY /y %CLEANUP_LOG_FILE% "%TEST_RESULT_DIR%"
@ECHO Refer to the cleanup.log file in %TEST_RESULT_DIR% to view clean up output.

@GOTO TerminateScriptBlock

:: ----------------------------------------------------------------------------
:: ----- ROUTINES--------------------------------------------------------------
:: -----------Test Runner Initialisation---------------------------------------
:BeginTestRunnerInitBlock
@ECHO OFF
SET TEST_RUNNER_EXE_NAME=vstest.console.exe
SET TEST_RUNNER_VERSIONS=" 11.0" " 12.0" " 14.0" "\2017\Professional" "\2017\TestAgent"
SET TEST_RUNNER_PATH_PREFIX=%PROGRAMFILES(x86)%\Microsoft Visual Studio
SET TEST_RUNNER_PATH_POSTFIX=Common7\IDE\CommonExtensions\Microsoft\TestWindow\%TEST_RUNNER_EXE_NAME%
SET DETECTED_TEST_RUNNER_VERSION=UNKNOWN
SET VSTEST_LOCATION=UNKNOWN
ECHO Determining a path to the test runner (%TEST_RUNNER_EXE_NAME%).

FOR %%v IN (%TEST_RUNNER_VERSIONS%) DO FOR %%v IN (%TEST_RUNNER_VERSIONS%) DO call :CHECK_VSTEST_LOCATION %%v
goto CHECK_VSTEST_LOCATION_END

:CHECK_VSTEST_LOCATION
set vstest_version=%1
set vstest_version=%vstest_version:"=%
IF EXIST "%TEST_RUNNER_PATH_PREFIX%%vstest_version%\%TEST_RUNNER_PATH_POSTFIX%" (
    SET DETECTED_TEST_RUNNER_VERSION=%vstest_version%
    SET VSTEST_LOCATION="%TEST_RUNNER_PATH_PREFIX%%vstest_version%\%TEST_RUNNER_PATH_POSTFIX%"
  )
goto :eof
:CHECK_VSTEST_LOCATION_END

IF NOT EXIST %VSTEST_LOCATION% (
  SET ERRORLEVEL=-1
  SET EXIT_MSG=ERROR: No %TEST_RUNNER_EXE_NAME% was found on %COMPUTERNAME%. MS Visual Studio 2012.1 or better is required.
  GOTO TerminateScriptBlock
) ELSE ECHO + %TEST_RUNNER_EXE_NAME% v%DETECTED_TEST_RUNNER_VERSION% was found.

@ECHO ON
@GOTO EndTestRunnerInitBlock
:: -----------Perform Verification of Parameters before Launching Tests--------
:BeginVerificationBeforLaunch
IF NOT EXIST "%TEST_EXECUTION_DIR%\%TEST_CONTAINER%.dll" (
  SET ERRORLEVEL=-1
  SET EXIT_MSG=ERROR: %TEST_CONTAINER%.dll assembly was not found in %TEST_EXECUTION_DIR%. The tests cannot be launched.
  GOTO TerminateScriptBlock
)

IF NOT EXIST "%RUN_SETTINGS_FILE_LOCATION%" (
  SET ERRORLEVEL=-1
  SET EXIT_MSG=ERROR: %RUN_SETTINGS_FILE_LOCATION% run settings file was not found. The tests cannot be launched.
  GOTO TerminateScriptBlock
)

IF NOT EXIST "%TEST_SETTINGS_FILE_LOCATION%" (
  SET ERRORLEVEL=-1
  SET EXIT_MSG=ERROR: %TEST_SETTINGS_FILE_LOCATION% test settings file was not found. The tests cannot be launched.
  GOTO TerminateScriptBlock
)

GOTO EndVerificationBeforLaunch
:: -----------Create and Publish a QReport-------------------------------------
:: generate an html file and email results
:BeginGenerateQReport
@SET QREPORT_LOCATION="\\cobalttesttools.int.westgroup.com\cobalttesttools$\QED\LegalEdQuality\Tools"
@SET QREPORT_PARAMS=/trxFile="%TEST_RESULT_DIR%\%TEST_RESULT_FILENAME%.trx" /emailfrom="%EMAIL_FROM%" /emailto="%EMAIL_TO%" 

:: if comment files exist, use them
IF EXIST "%TEST_SOURCE_DIR%\%TEST_CONTAINER%.xml" SET QREPORT_PARAMS=%QREPORT_PARAMS% /commentfiles="%TEST_SOURCE_DIR%\%TEST_CONTAINER%.xml"

:: if error email is defined, use it
IF NOT "%EMAIL_ERROR_TO%"=="" SET QREPORT_PARAMS=%QREPORT_PARAMS% /errorEmailTo="%EMAIL_ERROR_TO%"

%QREPORT_LOCATION%\QReport.exe %QREPORT_PARAMS%
@GOTO CleanUpScriptBlock
:: -----------Program Termination Section--------------------------------------
:TerminateScriptBlock
@ECHO OFF
IF %ERRORLEVEL% NEQ 0 ( ECHO The script has terminated with the following error code: %ERRORLEVEL%.) ELSE ( ECHO The script has terminated. )
IF DEFINED EXIT_MSG ECHO Termination message is: %EXIT_MSG%.
GOTO :eof
:: ----------------------------------------------------------------------------

:: --- CLEANUP Func ---
:CLEANUP
:: Clean-up temp folder
@SETLOCAL
@SET CLEANUP_DIR=%~1
@SET MASK=%~2
echo ------ Attempt to delete all files from %CLEANUP_DIR%\%MASK% ------

FOR %%G IN (TRUE, FALSE) DO (forfiles /P %CLEANUP_DIR% /M %MASK% /C "cmd /c if @isdir==%%G del /s/q @file " >>%CLEANUP_LOG_FILE% 2>&1)

echo Ok...
echo ------ Attempt to delete all folders from %CLEANUP_DIR% with mask: %MASK%------
for /d %%p in (%CLEANUP_DIR%\%MASK%) Do rd /Q /S "%%p" >>%CLEANUP_LOG_FILE% 2>&1
echo Ok...
@ENDLOCAL
:: --- /CLEANUP Func ---