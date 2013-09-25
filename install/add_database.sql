create database @database;
CREATE USER '@database'@'localhost' IDENTIFIED BY '@database';
GRANT ALL PRIVILEGES ON @database.* TO '@database'@'localhost';
CREATE USER '@database'@'%' IDENTIFIED BY '@database';
GRANT ALL PRIVILEGES ON @database.* TO '@database'@'%';
FLUSH PRIVILEGES;
quit

