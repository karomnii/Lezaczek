# Lezaczek

## Backend
To locally run backend you have to have MS SQL server running

To connect backend to the database, export these Environment variables with correct values:
- SQL_SERVER_TESTS (in format jdbc:sqlserver://(hostname);databaseName=(name);)
- TEST_USER
- TESTER_PASS

Alternatively you can edit **application.properties** file in *src/main/resources*

If these are correctly set you should be able to run **make run-test-build** in *backend* folder
