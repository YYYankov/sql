#1 ZADCACHA

DELIMITER $
DROP PROCEDURE IF EXISTS upr1 $
CREATE PROCEDURE upr1(IN coach_name VARCHAR(255))
BEGIN
SELECT coaches.name, sports.name, sportGroups.location, sportGroups.hourOfTraining
FROM coaches join sportGroups
ON coaches.id-sportGroups.coach.id JOIN sports
ON sports.id-sportGroups.sport.id JOIN student_sport
ON sportGroups.id=student_sport.sportGroup.id JOIN students
ON students.id-student_sport.student.id
WHERE coaches.name=coach_name;
END $
DELIMITER ;

CALL upr1("Ivan Todorov Petkov")


#2 ZADCACHA

DELIMITER $
DROP PROCEDURE if EXISTS upr2 $
CREATE PROCEDURE upr2(IN  sp_id INT)
Begin
SELECT coaches. name, sports.name, students.name
FROM coaches JOIN sportGroups
On coaches.id=sportGroups.coach_id JOIN sports
ON sports.id-sportGroups.sport_id JOIN student_sport
ON sportGroups.id=student_sport.sportGroup_id JOIN students
ON students.id=student_sport.student_id
WhERE sports.id=sp_id;
END $
DELIMITER $


#3 ZADCACHA

DELIMITER $
DROP PROCEDURE IF EXISTS upr3 $
CREATE PROCEDURE upr3(IN st_name VARCHAR(255), IN year_in INT) 
BEGIN
SELECT students.name, taxespayments.year, AVG(taxespayments-paymentAmount)
FROM students JOIN taxespayments
ON students.id-taxespayments.student_id
WHERE taxespayments.year=year_in
GROUP BY names, year;
END $
DELIMITER $


#4 ZADCACHA


DELIMITER $
DROP PROCEDURE IF EXISTS upr4 $
CREATE PROCEDURE upr4(IN coach_name VARCHAR(255))
BEGIN
DECLARE result INT DEFAULT 0;
if( (SELECT COUNT (spontGroups.id)
	FROM coaches JOIN sportGroups
	ON coaches.id=sportGroups.coach_id
	WHERE coaches.name=coach_name
	GROUp BY coach.id) IS NOT NULL)
THEN SET result = (SELECT COUNT (sportGroups.id)
	FROM coaches JOIN sportGroups oN coaches.id-sportGroups.coach_id
	WHERE coaches.name=coach_name
	GROUP BY coach.id);
ELSE SET result = 0;
END if;
END;
$
DELIMITER ;


#5 ZADCACHA
use transaction_test;
DELIMITER $
DROP PROCEDURE IF EXISTS upr5 $
CREATE PROCEDURE upr5 (IN sendId INT, IN recId INT, IN money DECIMAL)
Begin 
IF (SELECT ((SELECT id FROM customer _accounts WHERE id = 1)customer_accountscustomers iS NOT NULL 
AND (SELECT id FROM customer_accounts WHERE id = 2) IS NOT NULL) > 0)
then
UPDATE customer_accounts
SET amount = amount - money
WHERE id = sendId;
IF (ROW_COUNT () = 0)
THEN
SELECT "BAD IDS";
END IF;
UPDATE customer_accounts
SET amount = amount + money
WHERE id = recId;
IF (ROW_COUNT() = 0)
THEN
SELECT "BAD IDS";
END IF;
ELSE
SELECT "BAD IDS";
END IF;
END $
DELIMITER $


#6 ZADCACHA
USE transaction_test;

DELIMITER $$
DROP PROCEDURE IF EXISTS upr6 $$
CREATE PROCEDURE upr6 (IN sender_name VARCHAR(255), IN receiver_name VARCHAR(255), 
						IN currency_type VARCHAR(255), IN transfer_amount DECIMAL(18,2))
BEGIN
    DECLARE sender_id INT;
    DECLARE receiver_id INT;
    SELECT id INTO sender_id
    FROM customer_accounts
    WHERE customer_name = sender_name AND currency_type = currency_type;
    
    IF sender_id IS NULL THEN
        SELECT 'Invalid';
    END IF;

    SELECT id INTO receiver_id
    FROM customer_accounts
    WHERE customer_name = receiver_name AND currency_type = currency_type;
    
    IF receiver_id IS NULL THEN
        SELECT 'Invalid';
    END IF;
    
    UPDATE customer_accounts
    SET amount = amount - transfer_amount
    WHERE id = sender_id AND amount >= transfer_amount;
    
    IF ROW_COUNT() = 0 THEN
        SELECT 'no money';
    END IF;

    UPDATE customer_accounts
    SET amount = amount + transfer_amount
    WHERE id = receiver_id;
    
    SELECT 'Transfer successful' ;
END $$
DELIMITER ;

