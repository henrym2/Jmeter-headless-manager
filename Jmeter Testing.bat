@echo off
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit)

title jmeter headless
::Read config from file. If file is empty/doesn't exist, generate new file with default values.
if not Exist "config.txt" (
	echo _output=C:\Jmeter-test-results\>>config.txt
	echo _scripts=C:\Jmeter-test-scripts\>>config.txt
) else if "config.txt"=="0" (
	echo _output=C:\Jmeter-test-results\>>config.txt
	echo _scripts=C:\Jmeter-test-scripts\>>config.txt
)

for /f "delims== tokens=1,2" %%G in (config.txt) do set %%G=%%H
::_scripts=C:\Jmeter-test-scripts
::_output=C:\Jmeter-test-results

::Generate Timestamps for each item
SET _timeStamp=%DATE:~0,2%-%DATE:~3,2%-%DATE:~6,4%_%TIME:~0,2%~%TIME:~3,2%
SET _timeStamp=%_timeStamp: =%

echo List of stored Jmeter test files ::: in the Jmeter-test-scripts folder
echo.
::Print the file name sans extension
for /R "%_scripts%" %%f in (*.jmx) do (
	@echo %%~nf
)

@echo off
echo.


SET /P _configFlag= Configure paths?(Y/N) : 
IF /I "%_configFlag%"=="Y" (
	GOTO config
)else (
	GOTO test
)

:test
SET /P _testName= Please enter the test you wish to run or All to run each in sequence : 

IF /I not "%_testName%"=="all" (
::Verify that the script you intend to run exists. 
	IF NOT EXIST %_scripts%%_testName%.jmx (
		echo file not found 
		echo.
		cmd exit
	)
	::Run the Jmeter test based on the selected test item.
	echo Results will be stored in C:\Jmeter-test-results, under the file and folder "%_output%%_testName%-%_timeStamp%.jtl" and "%_output%%_testName%-%_timeStamp%\"
	cd C:\apache-jmeter-4.0\bin
	::Call Jmeter itself
	jmeter -n -t %_scripts%%_testName%.jmx -l %_output%%_testName%-%_timeStamp%.jtl -e -o %_output%%_testName%-%_timeStamp%\
	@echo %%~nf completed test at %_timeStamp% >> log.txt
	cd \
	echo Test Complete, press any key to exit
	pause
	cmd exit
	
::ALL
) else (
	::Parse through each test script and run each test in sequence
	for /R "C:\Jmeter-test-scripts" %%f in (*.jmx) do (
		SET _timeStamp = %DATE:~0,2%,%DATE:~3,2%,%DATE:~6,4%_%TIME:~0,2%:%TIME:~3,2%
		echo Results will be stored in C:\Jmeter-test-results, under the file and folder "%_output%%%~nf-%_timeStamp%.jtl" and "%_output%%%~nf-%_timeStamp%\
		cd C:\apache-jmeter-4.0\bin
		jmeter -n -t %_scripts%%%~nf.jmx -l %_output%%%~nf-%_timeStamp%.jtl -e -o %_output%%%~nf-%_timeStamp%\
		@echo %%~nf completed test at %_timeStamp% >> log.txt
		cd \
	)
)

:config

::Initiate config mode, delete and re-generate config file based on new options
DEL config.txt
SET /P _output= Please enter the output location for the test results : 
echo Results output path set to %_output% 
echo _output=%_output%>>config.txt
SET /P _scripts= Please enter the input location for the test scripts :
echo Test input path set to %_input%
echo _scripts=%_scripts%>>config.txt

::Offer to run tests based on the new config settings

SET /P _configFlag= Run tests? (Y/N) : 

if /I "%_configFlag%"=="Y" (
	GOTO test
)else (
	cmd exit
)



