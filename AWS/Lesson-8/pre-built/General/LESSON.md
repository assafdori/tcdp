Old Setup:
1. Run the docker-compose localy and fill the database with data (init.sql)
2. Exec to the mysql container and dump the data:
   1. mysqldump -u root -ppassword --databases Sales_Data Store_Info Inventory store_info > dump.sql
3. Copy the file to local machine
   1. docker cp old-setup-mysql-1:/dump.sql .

Cloud Setup:
1. Create ec2 in public subnet and deploy mysql UI in docker container
   1. scp -i ~/Downloads/labsuser.pem dump.sql ec2-user@3.235.1.56:/home/ec2-user
   2. docker cp dump.sql mysql:/
2. Create ec2 in private subnet and deploy mysql DB in docker container
3. Restore the data to the mysql DB
4. Connect the mysql UI to the DB and check the migration status

RDS: Setup:
5. Create mysql in RDS in private subnet
6. Connect the mysql UI to the RDS
7. Migrate the data from the container to the RDS

8. Create RDS snapshot and restore from snapshot, connect to the new RDS (delete the old one)
9. Create read replica

Extra:
9.  Aurora - Explain
10. DMS - Explain

Extra: EBS Lab
Extra: RDS events lambda
