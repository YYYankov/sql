(SELECT c.name as Coach, sg.location as Place
FROM coaches as c LEFT JOIN sportGroups as sg
ON c.id = sg.coach_id)
UNION
(SELECT coaches.id,sportGroups.location
FROM coaches RIGHT JOIN sportGroups
ON coaches.id = sportGroups.coach_id);

SELECT firstStud.name as Student1, secondStud.name as Student2, sports.name as Sport
FROM students as firstStud JOIN students as secondStud
ON firstStud.id < secondStud.id
JOIN sports ON(
				firstStud.id IN(
								SELECT student_id
                                FROM student_sport
                                WHERE sportGroup_id IN (
														SELECT id 
                                                        FROM sportGroups WHERE sportgroups.sport_id = sports.id)) 
AND (secondStud.id IN (SELECT student_id
						FROM student_sport WHERE sportGroup_id IN(
																	SELECT id 
                                                                    FROM sportgroups WHERE sportgroups.sport_id = sports.id)))) 
                                                                    
WHERE firstStud.id IN(SELECT student_id
					FROM student_sport WHERE sportGroup_id IN (
                    SELECT sportGroup_id
                    FROM student_sport WHERE student_id = secondStud.id))
ORDER BY sport;


SELECT students.name, students.class, students.phone
FROM students
INNER JOIN student_sport ON students.id = student_sport.student_id 
INNER JOIN sportGroups ON student_sport.sportGroup_id = sportGroups.id
INNER JOIN sports ON sportGroups.sport_id = sports.id
WHERE sports.name = "Football";

SELECT DISTINCT coaches.name
FROM coaches 
INNER JOIN sportGroups ON sportGroups.coach_id = coaches.id 
INNER JOIN sports ON sportGroups.sport_id = sports.id 
WHERE sports.name = 'Volleyball';

SELECT coaches.name
FROM coaches
JOIN sportgroups ON sportgroups.coach_id = coaches.id
JOIN(
SELECT student_sport.sportgroup_id
FROM student_sport
JOIN students ON student_sport.student_id = students.id
WHERE students.name = 'Iliyan Ivanov'
)
AS student_sport_table ON student_sport_table.sportGroup_id = sportGroups.id;


