#курсори
use school_sport_clubs;
drop procedure if exists  CursorTest;
delimiter |
create procedure CursorTest()
begin
declare finished int;
declare tempName varchar(100);
declare tempEgn varchar(10);
declare coachCursor CURSOR for
SELECT name, egn
from coaches
where month_salary is not null;
declare continue handler FOR NOT FOUND set finished = 1;
set finished = 0;
OPEN coachCursor;
coach_loop: while( finished = 0)
DO
FETCH coachCursor INTO tempName,tempEgn;
       IF(finished = 1)
       THEN 
       LEAVE coach_loop;
       END IF;	
       SELECT tempName,tempEgn; # or do something with these variables...
end while;
CLOSE coachCursor;
SET finished = 0;
SELECT 'Finished!';
end;
|
delimiter |


	CALL CursorTesT;
