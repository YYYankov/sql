CREATE DATABASE airport;
USE airport;

CREATE TABLE departments(
id INT NOT NULL auto_increment,
manager VARCHAR(255) NOT NULL,
name VARCHAR(60) NOT NULL,
PRIMARY KEY(id)

);

CREATE TABLE employees (
id INT NOT NULL auto_increment PRIMARY KEY,
department_id INT NOT NULL,
name VARCHAR(120) NOT NULL,
egn INT(10) NOT NULL UNIQUE,
position VARCHAR(120) NOT NULL,
CONSTRAINT FOREIGN KEY (department_id) REFERENCES departments(id) ,
CONSTRAINT FOREIGN KEY (manager_id) REFERENCES employees(id) 
);

CREATE TABLE planes(
id INT NOT NULL auto_increment PRIMARY KEY,
brand VARCHAR(120) NOT NULL,
number VARCHAR(120) NOT NULL,
year YEAR NOT NULL,
capacity INT NOT NULL
 );
 
 CREATE TABLE flights(
id INT NOT NULL auto_increment PRIMARY KEY,
pilot_id INT NOT NULL,
attendant_id INT NOT NULL,
departureTime DATETIME NOT NULL,
arrivalTime DATETIME NOT NULL,
CONSTRAINT FOREIGN KEY (plane_id) REFERENCES planes(id) ,
CONSTRAINT FOREIGN KEY (pilot_id) REFERENCES employees(id),
CONSTRAINT FOREIGN KEY (attendant_id) REFERENCES employees(id)
 );
 