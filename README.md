# Remote Activity Monitor

Codes running on IRIS for Remote Activity Monitor. Version IRIS-2019.1.0.510.0-win_x64 (Dev Type, Mini Security)

## Deployment

1. Create a new local database called `RAM`.

2. Create a new namespace called `RAM`. Select `RAM` database for globals and routines. Enable namespace for business production.

3. Open a terminal. Switch to `%SYS` namespace. Type `DO ^BACKUP`.

4. Choose 3: `Restore Selected or Renamed Directories`. Input cbk file location, e.g. `C:\FullDBList_20190918_002.cbk`. Use default options for following steps, but make sure the directory for database is correct.

5. Configure firewall to allow IRIS ports.

6. Configure SSL/TLS for email account in system configuration. Enter the password of email account at private key password. Open class file `zsys.Request.EmailAlertRequest` and replace `InitialExpression` of `Destination` with your own email address.

7. Go to business production. Click `Recover` if necessary. Click `EmailAlertOperation` and configure email in basic settings and connection settings. Start the business production.

8. Configure Home Server IP Address and Port number in class file `zsys.RAM.Attribute.HomeServerPort`.

9. Enable data collection on system start-up. Create a `ZSTART` routine in `%SYS` namespace. The code can be found in `%ZSTART.mac`.

10. Enable data collection periodically. Import a task in Task Manager. Use the file called `DataCollection.xml`. Click `Run`.

11. Use `DO ##class(zsys.RAM.Instance).Cycle()` to trigger data collection and sending manually.