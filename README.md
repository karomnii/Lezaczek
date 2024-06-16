# Lezaczek

# Required technologies and applications

[Java 17] (https://www.oracle.com/java/technologies/downloads/#java17) &nbsp;&nbsp; //Setting PATH and JAVA_HOME is needed

[MSQL SERVER] (https://www.microsoft.com/en-us/sql-server/sql-server-downloads) &nbsp;&nbsp; //We recommend the developer version, default settings

[Android Studio] (https://developer.android.com/studio)

You will need to install maven and makefile, for this we reccomend the chocolatey packet manager for windows

Open cmd with Admin privileges and install chocolatey:

```
winget install Chocolatey.Chocolatey
```

Restart the cmd and install make and maven:

```
choco install maven
```

```
choco install make
```

Enable TCP/IP connection with the database:
1. Open SQL server configuration manager
2. Choose SQL Native Client configuration from the leftside menu
3. Choose Client Protocols
4. Enable TCP/IP option


 
## Frontend
In order to run frontend
1. Download flutter SDK zip from: https://docs.flutter.dev/get-started/install/windows/mobile?tab=download
2. Extract files. **Important:** developers suggest that you should consider ```C:\users\{username}``` or ```C:\Users\{username}\AppData\Local``` paths. You shouldn't install flutter inside a path that (1) contains special characters or spaces or inside path (2) that requires elevated privileges or when your path meets both of these conditions
3. Update your environment variable PATH by adding *(unzip directory)\flutter\bin folder*
4. Install dart & flutter plugins in Android Studio, then restard IDE
5. Open project **'Lezaczek/frontend'** via Android Studio. **Important:** if Lezaczek will be opened instead of Lezaczek/frontend, errors with pubspec.yaml file and directories will occur
6. **Dart SDK is not configured** will pop up - click **Open Dart settings** and enter following configuration:
    - Enable Dart support for project 'frontend'
    - Dart SDK path: *(flutter directory)\flutter\bin\cache\dart-sdk*
    - Enable Dart support for the following modules: Project 'frontend'
    - Click apply & ok
7. Warning about pub get dependencies will pop up - click *get dependencies* (alternatively: open terminal and enter *dart pub get*). If there's still problem, try with *upgrade dependencies* (or *dart pub upgrade*)
### How to run this project on Android Emulator?(After turning the backend on)
In case you haven't created any emulators:
1. Open **Tools** -> **Device Manager** and click **Add a new device...**
2. Enter your configuration including device model, amount of RAM memory etc.
3. Close the wizard
Enable port forwarding for connection of the emulated device with the backend:
1. In the emulator open chrome browser, type in the localhost:8080/api/v1/hello. Until you can see the greetings message it is not set up.
2. Open Chrome or other chromium based browser on your computer. Type in the "//inspect/:devices#devices"
3. Open the "Configure..." button on the site next to "discover network targets" which should be checked.
4. Add "localhost:5554" and "localhost:5555" to the list and enable port forwarding at the bottom of the box.
5. Try to refresh the page on the emulator, if you don't see the greetings message there is something wrong
If your emulator is already set up:
1. Run the device. It will be automatically selected as the device that can run 'main.dart' configuration
2. Run 'main.dart' configuration. After a while, the application will start.
**Important:** if you're experiencing troubles with starting virtual device, edit its configuration by switching **Emulated Performance** -> **Graphics** to *Software*. If it didn't make any difference, switch to *Hardware*

## Database

Open the repository database folder, choose the lezaczek.sql file
Open this file in microsoft sql server managment studio and execute the querry

## Backend

To connect backend to the database, export these Environment variables with correct values:
- SQL_SERVER_TESTS (in format jdbc:sqlserver://(hostname);databaseName=(name);)
- TEST_USER
- TESTER_PASS
- JWT_SECRET

Alternatively you can edit **application.test.test.properties** file in *backend/src/main/resources*

If these are correctly set you should be able to run this command in the cmd in *backend* folder

```
 make run-test-build-windows
```

## API Description

    GET /api/v1/hello
    Used to verify if http server is running. Returns "Greetings from Spring Boot!"

    POST /api/v1/auth/login
    Used to login the user. Accepts JSON in format {email:String, password:String}.
    Returns {response:"ok", refreshToken:String, accessToken:String} or {response:"error", errorReason:String}
    Sends Cookies accessToken (httpOnly, Secure, path:"/") and refreshToken (httpOnly, Secure, path:"/api/v1/auth/refresh")

    PUT /api/v1/auth/register
    Used to register the user. Accepts JSON in format {email:String, name:String, surname: String, password: String, gender: [0-2]}.
    Returns {response: "ok"} or {response: "error", errorReason:String}

    POST /api/v1/auth/refresh
    Used to refresh the users authToken. Accepts Cookie authToken or Cookie refreshToken.
    Returns new accessToken cookie and JSON {response:"ok",accessToken:String} or {response:"error", errorReason:String}, without the cookie

    GET /api/v1/events/{id}
    Used to get event data (by the user that created it). Accepts Cookie authToken or Cookie refreshToken.

    GET /api/v1/events/date/{YYYY-MM-DD}
    Used to get all events on a selected date (by the user that created them). Accepts Cookie authToken or Cookie refreshToken.

    PUT /api/v1/events/
    Used for adding events. Accepts Cookie authToken or Cookie refreshToken. Accepts JSON in format {"eventId": int, "userID": int, "name": String,"description": String,
    "place": String,"eventType": String,"dateStart": Date(YYYY-MM-DD),"dateEnd": Date(YYYY-MM-DD),"startingTime": Time(HH:MM:SS),"endingTime": Time(HH:MM:SS)}
    Returns {response: "ok"} or {response: "error", errorReason:String}

    POST /api/v1/events/
    Used for updating events. Accepts Cookie authToken or Cookie refreshToken. Accepts JSON in format {"eventId": int, "userID": int, "name": String,"description": String,
    "place": String,"eventType": String,"dateStart": Date(YYYY-MM-DD),"dateEnd": Date(YYYY-MM-DD),"startingTime": Time(HH:MM:SS),"endingTime": Time(HH:MM:SS)}
    Returns {response: "ok"} or {response: "error", errorReason:String}

    DELETE /api/v1/events/{id}
    Used to delete event (by the user that created it). Accepts Cookie authToken or Cookie refreshToken.
    Returns {response: "ok"} or {response: "error", errorReason:String}

