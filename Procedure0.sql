use school_sport_clubs;
DELIMITER $
DROP PROCEDURE IF EXISTS testProc $
CREATE PROCEDURE testProc()
BEGIN 
	SELECT sports.name,sportsGroups.locations
    from sports JOIN sportsGroups
    ON sports.id=sportgroups.sport_id;
END $
DELIMITER ;

DELIMITER $
DROP PROCEDURE IF EXISTS testProc $
CREATE PROCEDURE testProc(INOUT testParam VARCHAR (255))
BEGIN 
	SELECT testParam;
    set testProc=`ivana`;
    select testParam;
END $
DELIMITER ;
set @name=`George`;
CALL testProc(@name);
select@name;

use school_sport_clubs;

#drop procedure getPaymentPeriod;
delimiter |
CREATE procedure getPaymentPeriod(IN studId INT, IN groupId INT, IN paymentYear INT)
BEGIN
DECLARE countOfMonths tinyint;
DECLARE monthStr VARCHAR(10);
DECLARE yearStr varchar(10);
SET monthStr = 'MONTH';
SET yearStr = 'YEAR';

	SELECT COUNT(*)
    INTO countOfMonths
    FROM taxespayments
    WHERE student_id = studId
    AND group_id = groupId
    AND year = paymentYear;
    
    CASE countOfMonths
    WHEN 0 THEN SELECT 'This student has not paid for this group/year!' as PAYMENT_PERIOD;
    WHEN 1 THEN SELECT concat('ONE_', monthStr) as PAYMENT_PERIOD;
    WHEN 3 THEN SELECT concat('THREE_',monthStr, 'S') as PAYMENT_PERIOD;
    WHEN 6 THEN SELECT concat('SIX_',monthStr,'S') as PAYMENT_PERIOD;
    WHEN 12 THEN SELECT yearStr as PAYMENT_PERIOD;
    ELSE
		SELECT 	concat(countOfMonths,monthStr,'S') as PAYMENT_PERIOD;
	END CASE;
END;
|
DELIMITER ;


use school_sport_clubs;
drop procedure getAllPaymentsAmountOptimized;
delimiter |
CREATE procedure getAllPaymentsAmountOptimized(IN firstMonth INT, IN secMonth INT, IN paymentYear INT, IN studId INT)
BEGIN
    DECLARE iterator int;
    CREATE TEMPORARY TABLE tempTbl(
    student_id int, 
    group_id int,
    paymentAmount double,
    month int
    ) ENGINE = Memory;
    
    
	IF(firstMonth >= secMonth)
    THEN 
		SELECT 'Please enter correct months!' as RESULT;
	ELSE IF((SELECT COUNT(*)
			FROM taxesPayments
			WHERE student_id =studId ) = 0)
        THEN SELECT 'Please enter correct student_id!' as RESULT;
		ELSE
	
	SET ITERATOR = firstMonth;

		WHILE(iterator >= firstMonth AND iterator <= secMonth)
		DO
			INSERT INTO tempTbl
			SELECT student_id, group_id, paymentAmount, month
			FROM taxespayments
			WHERE student_id = studId
			AND year = paymentYear
			AND month = iterator;
    
			SET iterator = iterator + 1;
		END WHILE;
		END IF;
    
    END IF;
		SELECT *
        FROM tempTbl;
        DROP TABLE tempTbl;
END;
|
DELIMITER ;
CALL getAllPaymentsAmount(6,1,2021,1);



delimiter $
create procedure inParamProcWithChangedParam(IN nameParam VARCHAR(255))
begin
SET nameParam = 'Ivan Petkov';
end;
$
delimiter ;

SET @testCoachName = 'Иван Тодоров Петров';
call inParamProcWithChangedParam(@testCoachName);
SELECT  @testCoachName;