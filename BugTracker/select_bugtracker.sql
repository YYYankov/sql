CREATE VIEW `high_complexity_bugs` AS

	SELECT `devs`.`name` AS `Developer`, 
			`projects`.`id` AS `Project ID`, 
			`bugs`.`logged_time` AS `Logged time`, 
			`bugs`.`status` AS `Status`
            
	FROM `devs` 
	JOIN `project_devs` ON `devs`.`id` = `project_devs`.`id_dev`
	JOIN `projects` ON `project_devs`.`id_project` = `projects`.`id`
	JOIN `bugs` ON `projects`.`id` = `bugs`.`id_project`
	JOIN `complexities` ON `bugs`.`id_complex` = `complexities`.`id`
	WHERE `complexities`.`rarity` = "high";
    
    
    
	SELECT `attachments`.`attachment_id` AS `Attachment ID`,
            `bugs`.`descr` AS `Description`,
             `devs`.`name` AS `Developer`
             
	FROM `attachments`
	INNER JOIN `bugs` ON `attachments`.`bug_id `= `bugs`.`id`
	INNER JOIN `devs` ON `attachments`.`dev_id` = `devs`.`id`;