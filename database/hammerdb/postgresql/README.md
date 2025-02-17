# PostgresQL

## Installation

```
sudo yum update  
sudo yum install postgresql-server postgresql-contrib
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo -u postgres createuser your_user
sudo -u postgres createdb -O your_user your_database
```

### Fix for missing libgptcl2.1.1.so

```
dnf install libpq
export LD_LIBRARY_PATH=/usr/lib64/
ldd $PATH/workloads/db/HammerDB-4.8/lib/pgtcl2.1.1/libpgtcl2.1.1.so
```

Should return correct linked files

### Fix network unreachable issu

Edit /var/lib/pgsql/data/pg_hba.conf to ensure that all methods are md5 to ensure outside connections are accepted.

