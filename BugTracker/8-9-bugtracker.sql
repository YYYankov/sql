USE bugtracker;
DELIMITER //

CREATE TRIGGER `check_unresolved_bugs` AFTER INSERT ON `bugs`
FOR EACH ROW
BEGIN
    DECLARE num_unresolved_bugs INT;
    SELECT COUNT(*) INTO num_unresolved_bugs
    FROM bugs
    WHERE id_complex = NEW.id_complex
    AND status IN ('new', 'addressed');

    IF num_unresolved_bugs > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Developer cannot be assigned to more than 5 unresolved bugs at a time';
    END IF;
END; //

DELIMITER ;

INSERT INTO bugs (descr, priority, status, logged_time, id_project, id_complex) VALUES
('UI button is not working', 'major', 'new', '2023-05-05 10:00:00', 1, 2),
('UI button is not working2', 'major', 'new', '2023-05-05 10:00:00', 1, 2),
('UI button is not working3', 'major', 'new', '2023-05-05 10:00:00', 1, 2),
('UI button is not working4', 'major', 'new', '2023-05-05 10:00:00', 1, 2);


DELIMITER //
CREATE PROCEDURE `bug_summary`()
BEGIN
    DECLARE done INT DEFAULT false;
    DECLARE bug_id INT;
    DECLARE bug_descr VARCHAR(255);
    DECLARE bug_priority ENUM('minor', 'medium', 'major', 'critical');
    DECLARE bug_status ENUM('new', 'addressed', 'failed', 'closed');
    DECLARE bug_time DATETIME;
    DECLARE bug_complexity VARCHAR(255);
    DECLARE bug_project VARCHAR(255);
    DECLARE bug_logs TEXT;
    DECLARE bug_logs_count INT DEFAULT 0;
    DECLARE bug_attachments_count INT DEFAULT 0;
    
    DECLARE cur CURSOR FOR SELECT b.id, b.descr, b.priority, b.status, b.logged_time, c.rarity, p.descr, b.logs
                            FROM bugs b
                            JOIN complexities c ON b.id_complex = c.id
                            JOIN projects p ON b.id_project = p.id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    DROP TEMPORARY TABLE IF EXISTS bug_summary;
    
    CREATE TEMPORARY TABLE bug_summary (
        id INT PRIMARY KEY,
        descr VARCHAR(255),
        priority ENUM('minor', 'medium', 'major', 'critical'),
        status ENUM('new', 'addressed', 'failed', 'closed'),
        logged_time DATETIME,
        complexity VARCHAR(255),
        project VARCHAR(255),
        logs_count INT,
        attachments_count INT
    );
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO bug_id, bug_descr, bug_priority, bug_status, bug_time, bug_complexity, bug_project, bug_logs;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET bug_logs_count = LENGTH(bug_logs) - LENGTH(REPLACE(bug_logs, ',', '')) + 1;
        
        SELECT COUNT(*) INTO bug_attachments_count FROM attachments WHERE bug_id = bug_id;
        
        INSERT INTO bug_summary (id, descr, priority, status, logged_time, complexity, project, logs_count, attachments_count)
        VALUES (bug_id, bug_descr, bug_priority, bug_status, bug_time, bug_complexity, bug_project, bug_logs_count, bug_attachments_count);
    END LOOP;
    
    CLOSE cur;
    
    SELECT * FROM bug_summary;
    
END
//

DELIMITER ;;

call `bug_summary`();