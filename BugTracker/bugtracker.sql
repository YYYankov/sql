CREATE SCHEMA IF NOT EXISTS `bugtracker`;
USE `bugtracker`;

CREATE TABLE IF NOT EXISTS `qas` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(255)  NOT NULL,
`email` VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `complexities` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`rarity` VARCHAR(255)  NOT NULL
);

CREATE TABLE IF NOT EXISTS `devs` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(255)  NOT NULL,
`role` VARCHAR(50) NOT NULL,
`email` VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `projects` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`descr` VARCHAR(255) NOT NULL,
`id_manager` INT NOT NULL,
`id_po` INT NOT NULL,
CONSTRAINT FOREIGN KEY (`id_manager`) REFERENCES `devs`(`id`),
CONSTRAINT FOREIGN KEY (`id_po`) REFERENCES `devs`(`id`)
);

CREATE TABLE IF NOT EXISTS `project_devs` (
`id_project` INT NOT NULL,
`id_dev` INT NOT NULL,
PRIMARY KEY(`id_project`, `id_dev`),
CONSTRAINT FOREIGN KEY (`id_project`) REFERENCES `projects`(`id`),
CONSTRAINT FOREIGN KEY (`id_dev`) REFERENCES `devs`(`id`)
);

CREATE TABLE IF NOT EXISTS `project_qas` (
`id_project` INT NOT NULL,
`id_qas` INT NOT NULL,
PRIMARY KEY(`id_project`, `id_qas`),
CONSTRAINT FOREIGN KEY (`id_project`) REFERENCES `projects`(`id`),
CONSTRAINT FOREIGN KEY (`id_qas`) REFERENCES `qas`(`id`)
);

CREATE TABLE IF NOT EXISTS `bugs`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`descr` VARCHAR(255) NOT NULL,
`priority` ENUM("minor",  "medium", "major",  "critical") NOT NULL,
`status` ENUM("new",  "addressed",  "failed",  "closed") NOT NULL,
`logged_time` DATETIME NOT NULL,
logs TEXT,
`id_project` INT NOT NULL,
`id_complex` INT NOT NULL,
CONSTRAINT FOREIGN KEY (`id_project`) REFERENCES `projects`(`id`),
CONSTRAINT FOREIGN KEY (`id_complex`) REFERENCES `complexities`(`id`)
);

CREATE TABLE `attachments` (
    `attachment_id` INT PRIMARY KEY,
    `bug_id` INT NOT NULL,
    `dev_id` INT NOT NULL,
    `attachment_filename` VARCHAR(255) NOT NULL,
    `attachment_size` INT NOT NULL,
    `attachment_type` VARCHAR(50) NOT NULL,
    FOREIGN KEY (`bug_id`) REFERENCES bugs(`id`),
    FOREIGN KEY (`dev_id`) REFERENCES devs(`id`)
);

CREATE VIEW `high_complexity_bugs` AS
    SELECT 
        `devs`.`name` AS `Developer`,
        `projects`.`id` AS `Project ID`,
        `bugs`.`logged_time` AS `Logged time`,
        `bugs`.`status` AS `Status`
    FROM
        `devs`
            JOIN
        `project_devs` ON `devs`.`id` = `project_devs`.`id_dev`
            JOIN
        `projects` ON `project_devs`.`id_project` = `projects`.`id`
            JOIN
        `bugs` ON `projects`.`id` = `bugs`.`id_project`
            JOIN
        `complexities` ON `bugs`.`id_complex` = `complexities`.`id`
    WHERE
        `complexities`.`rarity` = 'high';

	SELECT 
    b.id as `ID`,
    b.priority as `Priority`,
    b.status as `Status`,
   CONCAT(b.descr, ' - ', a.attachment_filename) AS bug_and_attachment,
    a.attachment_size as `Size`
FROM
    bugs b
         JOIN
    attachments a ON b.id = a.bug_id;
    
SELECT 
    p.descr AS 'Description',
    d.name AS 'Dev name',
    COUNT(b.id) AS 'Bug count'
FROM
    projects p
        JOIN
    project_devs pd ON pd.id_project = p.id
		JOIN
    devs d ON d.id = pd.id_dev
        JOIN
    bugs b ON b.id_project = p.id 
GROUP BY p.id , d.id
HAVING COUNT(b.id) > 0
;


SELECT projects.id, projects.descr, COUNT(bugs.id) as bug_count
FROM projects
LEFT JOIN bugs ON bugs.id_project = projects.id
GROUP BY projects.id, projects.descr;


SELECT *
FROM `devs`
LEFT OUTER JOIN `project_devs` ON `devs`.`id` = `project_devs`.`id_dev`;


SELECT
    p.descr AS project_name,
    (SELECT COUNT(*) FROM bugs WHERE bugs.id_project = p.id) AS bug_count
FROM
    projects p;
    
SELECT id_complex as 'ID', SUM(attachment_size) as `Totatl attachment size`
FROM bugs
LEFT JOIN attachments ON bugs.id = attachments.bug_id
GROUP BY id_complex;
