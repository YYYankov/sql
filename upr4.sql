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





