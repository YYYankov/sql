use school_sport_clubs;
SELECT s.name, s.phone, sp.name AS sport
FROM students s
JOIN student_sport ss ON s.id = ss.student_id
JOIN sportGroups sg ON ss.sportGroup_id = sg.id
JOIN sports sp ON sg.sport_id = sp.id
WHERE sp.name = 'Football';

-- 2
SELECT c.name 
FROM coaches  as c
WHERE sport_id = 2;

SELECT c.name
From coaches as c
JOIN c ON sportGroups.coach_id=c.id
JOIN sportGroups on sportGroups.sport_id-sport.id
WHERE sport.name='Voleyball';

-- 3
SELECT s.name AS student_name, s.name AS sport_name, sg.dayOfWeek AS training_day, sg.location AS location
FROM student_sport ss
JOIN students st ON ss.student_id = st.id 
JOIN sportGroups sg ON ss.sportGroup_id = sg.id
JOIN coaches c ON sg.coach_id = c.id
JOIN sports s ON sg.sport_id = s.id
WHERE st.name='Maria Hristova Dimova';


-- 4

SELECT students.id, students.name as StudentName, SUM(tp.paymentAmount) as SumOfAllPaymentPerGroup, tp.month as Month
FROM taxespayments as tp JOIN students 
ON tp.student_id = students.id
GROUP BY month, student_id
HAVING SumOfAllPaymentPerGroup >700
ORDER BY StudentName;	

-- 5

SELECT COUNT(student_id) as CountOFStudents
FROM students s
JOIN student_sport ss ON s.id = ss.student_id
JOIN sportGroups sg ON ss.sportGroup_id = sg.id
JOIN sports sp ON sg.sport_id = sp.id
WHERE sp.name = 'Football';
;

-- 6
SELECT c.name AS coach_name, s.name AS sport_name
FROM coaches c
LEFT JOIN sportGroups g ON c.id = g.coach_id
LEFT JOIN sports s ON g.sport_id = s.id
ORDER BY coach_name ASC;

-- 7
SELECT sports.name, sportgroups.location, COUNT(students.id)
FROM sports
JOIN sportgroups ON sportgroups.sport_id = sports.id
JOIN student_sport ON student_sport.sportGroup_id = sportgroups.id
JOIN students ON students.id = student_sport.student_id
GROUP BY sports.name, sportgroups.location
HAVING COUNT(students.id) > 3;


-- 8 
use transaction_test;
BEGIN;
UPDATE customer_accounts
SET amount = amount - 50000
WHERE customer_id IN (
	SELECT customers.id
	FROM customers
    WHERE customers.name = "Stoyan Pavlov Pavlov"
	) AND customer_accounts.currency = "BGN";
    
UPDATE customer_accounts
SET amount = amount + 50000
WHERE customer_id IN (
	SELECT customers.id 
	FROM customers
    WHERE customers.name = "Ivan Petrov Iordanov" 
	) AND customer_accounts.currency = "BGN";
COMMIT;

-- 9
SELECT *
from students as s1
JOIN students as s2 