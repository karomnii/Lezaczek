# Lezaczek
 
## Frontend
In order to run frontend, you need to have installed Android Studio
1. Download flutter SDK zip from: https://docs.flutter.dev/get-started/install/windows/mobile?tab=download
2. Extract files. **Important:** developers suggest that you should consider ```C:\users\{username}``` or ```C:\Users\{username}\AppData\Local``` paths. You shouldn't install flutter inside a path that (1) contains special characters or spaces or inside path (2) that requires elevated privileges or when your path meets both of these conditions
3. Update your environment variable PATH by adding *(unzip directory)\flutter\bin folder*
4. Install dart & flutter plugins in Android Studio, then restard IDE
5. Open project **'Lezaczek/frontend'** via Android Studio. **Important:** if Lezaczek will be opened instead of Lezaczek/frontend, errors with pubspec.yaml file and directories will occur
6. **Dart SDK is not configured** will pop up - click **Open Dart settings** and enter following configuration:
    a. Enable Dart support for project 'frontend'
    b. Dart SDK path: *(flutter directory)\flutter\bin\cache\dart-sdk*
    c. Enable Dart support for the following modules: Project 'frontend'
    d. Click apply & ok
7. Warning about pub get dependencies will pop up - click *get dependencies* (alternatively: open terminal and enter *dart pub get*). If there's still problem, try with *upgrade dependencies* (or *dart pub upgrade*)
### How to run this project on Android Emulator?
In case you haven't created any emulators:
1. Open **Tools** -> **Device Manager** and click **Add a new device...**
2. Enter your configuration including device model, amount of RAM memory etc.
3. Close the wizard
If your emulator is already set up:
1. Run the device. It will be automatically selected as the device that can run 'main.dart' configuration
2. Run 'main.dart' configuration. After a while, the application will start.
**Important:** if you're experiencing troubles with starting virtual device, edit its configuration by switching **Emulated Performance** -> **Graphics** to *Software*. If it didn't make any difference, switch to *Hardware*
### How to run this project using Chrome or Edge browser?
1. Click *no device selected*
2. Choose Chrome (web) or Edge (web) from the list
3. Run 'main.dart' configuration. After a while, the application will start.

## Backend to develop
To locally run backend you have to have MS SQL server running and have the TCP/IP option in Sql server configuration manager enabled

Have apache maven installed our version is 3.9.6

Have Java jdk with JAVA_HOME and Path set correctly, our version is jdk-17

Have the make installed for using a makefile

Import the database from database/lezaczek.sql

To connect backend to the database, export these Environment variables with correct values:
- SQL_SERVER_TESTS (in format jdbc:sqlserver://(hostname);databaseName=(name);)
- TEST_USER
- TESTER_PASS
- JWT_SECRET

Alternatively you can edit **application.test.test.properties** file in *backend/src/main/resources*

If these are correctly set you should be able to run **make run-test-build** in *backend* folder

## API Description

    GET /api/v1/hello
    Used to verify if http server is running. Returns "Greetings from Spring Boot!"

    POST /api/v1/auth/login
    Accepts JSON in format {email:String, password:String}.
    Returns {response:"ok", refreshToken:String, accessToken:String} or {response:"error", errorReason:String}
    Sends Cookies accessToken (httpOnly, Secure, path:"/") and refreshToken (httpOnly, Secure, path:"/api/v1/auth/refresh")

    PUT /api/v1/auth/register
    Accepts JSON in format {email:String, name:String, surname: String, password: String, gender: [0-2]}.
    Returns {response: "ok"} or {response: "error", errorReason:String}

    POST /api/v1/auth/refresh
    Accepts Cookie authToken or Cookie refreshToken.
    Returns new accessToken cookie and JSON {response:"ok",accessToken:String} or {response:"error", errorReason:String}, without the cookie

