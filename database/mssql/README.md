# Microsoft SQL Server 2022


1. start docker container
   
```bash
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_USERNAME=mssql" -e "MSSQL_SA_PASSWORD=ms-SQL-password25" \   
   -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest
```
2. enter into docker container
   
```bash
   docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ms-SQL-password25
```
3. Source bak file
```sql
USE [master];
GO
RESTORE DATABASE [AdventureWorks2022]
FROM DISK = '/var/opt/mssql/backup/AdventureWorks2022.bak'
WITH
    MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022_Data.mdf',
    MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf',
    FILE = 1,
    NOUNLOAD,
    STATS = 5;
GO
```
4. create bak file
```sql
USE SQLTestDB;
GO
BACKUP DATABASE SQLTestDB
TO DISK = 'c:\tmp\SQLTestDB.bak'
   WITH FORMAT,
      MEDIANAME = 'SQLServerBackups',
      NAME = 'Full Backup of SQLTestDB';
GO
```