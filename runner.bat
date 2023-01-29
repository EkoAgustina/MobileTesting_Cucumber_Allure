@ECHO OFF


::Enter Appium port, example => appiumPort=4723
set appiumPort=4723

::Enter Device Name, example => deviceName=127.0.0.1:21503
set deviceName=127.0.0.1:21503

::Enter Enter Apk, example => apps=app-clock.apk
set apps=wdio.apk

::Enter tags, example => tags=@smoke
set tags=@validSignup

ECHO:
ECHO ============================STARTING APPIUM SERVER===================================
if defined appiumPort (
    tskill node
    start /b appium --port %appiumPort%
)else (
    echo APPIUM PORT IS REQUIRED!
    exit 9
)
timeout /t 6 /nobreak

ECHO:
ECHO ============================START TESTING============================================
if defined deviceName (
    if defined apps (
        if defined tags (
            call mvn clean test -DdeviceName="%deviceName%" -Dapps="%apps%" -Dcucumber.filter.tags="%tags%"
        ) else (
            echo TAGS IS REQUIRED!
            timeout /t 3 /nobreak > NUL
        )
    ) else (
        echo APPS IS REQUIRED!
        timeout /t 3 /nobreak > NUL
    )
) else (
    echo DEVICE NAME IS REQUIRED!
    timeout /t 3 /nobreak > NUL
)

ECHO:
ECHO Testing Complete . . . . !
tskill node

::allure generate --clean && allure open