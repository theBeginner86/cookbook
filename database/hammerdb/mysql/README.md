# MYSQL

## Installation

```
sudo yum install https://mirror.stream.centos.org/9-stream/CRB/x86_64/os/Packages/mysql-libs-8.0.36-1.el9.x86_64.rpm 
sudo yum install mysql-community-client    
sudo yum install mysql-community-server
```

### Fix forgotten password

```
systemctl stop mysqld   
sudo systemctl set-environment MYSQLD_OPTS="--skip-grant-tables --skip-networking"   
systemctl start mysqld  
Mysql

FLUSH PRIVILEGES;
 ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass@1';
```

### Fix sock file cannot be accessed

```
Update .sock file location in bench.sh to ensure
```

### Fix out of disk space error
1. Method1 - clean re-install mysql
2. Method2 - surgical restart ;)
```
systemctl stop mysql


mkdir /var/run/mysqld/
chmod -R 777 /var/run/mysqld/

/usr/sbin/mysqld --upgrade=MINIMAL
/usr/sbin/mysqld --upgrade=FORCE
```

> In any emergency, make sure to stop before running anything otherwise it could lead to noop and entire linux box being stuck