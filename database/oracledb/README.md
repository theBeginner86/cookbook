1. start docker container
```bash
docker run -d --name oracle-db -p 1521:1521 -e ORACLE_PWD=oracle-db-PASS25 container-registry.oracle.com/database/enterprise:latest  
```
2. enter into docker container
```bash
docker exec -it oracle-db bash
```
3. open sql shell
```bash
sqlplus / as sysdba
```
4. 