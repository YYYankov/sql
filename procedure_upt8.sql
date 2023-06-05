use school_sport_clubs;


#upr1
create view stView
as 
select coaches.name as name, concat(sportgroups.id , " - " , sportgroups.location), 
sports.name as nameSp,  year(now()), month(now()),
salarypayments.salaryAmount
from coaches join sportgroups
on coaches.id  = sportgroups.coach_id
join sports
on sports.id = sportgroups.sport_id
join salarypayments
on salarypayments.coach_id = coaches.id
Where


#upr2
delimiter |
drop procedure if exists upr2;
create procedure upr2()
begin
	select students.id, students.name
    from students join sportgroups
    on students.id in (
		select student_id
        from student_sport
        where sportGroup_id = sportgroups.id
    )
    group by students.id
    having count(students.id) <= 1;
end;
|
delimiter |

call upr2;

#upr3
drop procedure if exists upr3;
delimiter |
create procedure upr3()
begin
	select coaches.id, coaches.name from coaches
    left join sportgroups as sg on coaches.id=sg.coach_id
    where coaches.id not in(
		select coach_id
    from sportgroups);
end;
|
delimiter ;

call upr3; 

#upr4
use transaction_test;
delimiter |
drop procedure if exists upr4;
create procedure upr4(IN from_currency VARCHAR(10),
    in to_currency VARCHAR(10),
    in amount DOUBLE,
    out converted_amount DOUBLE)
begin
    declare exchange_rate DOUBLE;
    IF from_currency = 'BGN' AND to_currency = 'EUR' THEN
        set converted_amount = amount * 0.51;
        
    elseif from_currency = 'EUR' AND to_currency = 'BGN' THEN
        set converted_amount = 1.94 * exchange_rate;
    else
        set converted_amount = amount;
    end if;
end;
|
delimiter |


#upr5
delimiter |
drop procedure if exists upr5;
create procedure upr5(in firstId int,
 in secondId int, 
 in transferAmount double
 OUT success bit)
begin
	declare firstCurrency varchar(5);
    declare secondCurrency varchar(5);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SELECT 'SQLException occured';
    
    select currency
    into firstCurrency
    from customer_accounts
    where id = firstId;
    
    select currency
    into secondCurrency
    from customer_accounts
    where id = secondId;
    
    IF ((firstCurrency != 'BGN' and firstCurrency != 'EUR') and (secondCurrency != 'BGN' and secondCurrency != 'EUR')) THEN
		select "The two currency must be either 'BGN' or 'EUR'!";
	else if ((select amount
			from customer_accounts
			where id = firstId) - transferAmount < 0)
		then
			select "Not enough money!";
		else
			start transaction;
				update customer_accounts
                set amount = amount - transferAmount
                where id = firstId;
		if ROW_COUNT() = 0 THEN
						SELECT 'no ';
                        rollback;
					else
					if (firstCurrency != secondCurrency)
                    then
						set @returnAmount = 0;
                        call upr4(transferAmount, firstCurrency, @returnAmount);
					else
						set @returnAmount = transferAmount;
					end if;
                    
                    update customer_accounts
                    set amount = amount + @returnAmount
                    where id = secondId;
                    
                     IF ROW_COUNT() = 0 THEN
						SELECT 'no ';
                        rollback;
					else
						commit;
					end if;
end;
|
delimiter |


