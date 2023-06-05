CREATE DATABASE IF NOT EXISTS newspaper;
use newspaper;

CREATE TABLE IF NOt EXISTS users(
id int AUTO_INCREMENT PRIMARY KEY,
name varchar(62) not null unique,
role ENUM('moderator','admin','user')
);
INSERT INTO users(name, role)
VALUES ("Petar", 'user'), ("Ivan",'admin'), ("Maria",'moderator'), ("Philip",'user');


CREATE TABLE articles(
id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(160) NOT NULL,
contents TEXT NOT NULL,
author_id INT NOT NULL,
published_on DATE NOT NULL,
moderator_id INT NULL DEFAULT NULL,
FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO articles(title, contents, published_on, author_id, moderator_id) 
VALUES
 ("Article 1", "Content of article 1...", "2012-03-12", 2, NULL),
("Article 2", "Content of article 2...", "2012-03-28", 3, NULL), 
("Article 3", "Content of article 3...", "2012-04-04", 3, NULL), 
("Article 4", "Content of article 4...", "2012-02-27", 2, NULL), 
("Article 5", "Content of article 5...", "2012-03-28", 3, 1), 
("Article 6", "Content of article 6...", "2012-04-04", 3, 2), 
("Article 7", "Content of article 7...", "2012-02-27", 2, 1), 
("Article 8", "Content of article 8...", "2012-02-27", 1, 2), 
("Article 9", "Content of article 9...", "2012-02-27", 1, NULL);

SELECT a.title, users.name
from articles as a
join users on a.author_id=users.id
where users.role= 'admin' and users.name='Ivan'