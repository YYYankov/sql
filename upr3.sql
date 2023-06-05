#1
USE school_sport_clubs;
SELECT students.name, students.class, students.phone
FROM students
INNER JOIN student_sport ON students.id = student_sport.student_id 
INNER JOIN sportGroups ON student_sport.sportGroup_id = sportGroups.id
INNER JOIN sports ON sportGroups.sport_id = sports.id
WHERE sports.name = "Football";
#2
SELECT DISTINCT coaches.name
FROM coaches 
INNER JOIN sportGroups ON sportGroups.coach_id = coaches.id 
INNER JOIN sports ON sportGroups.sport_id = sports.id 
WHERE sports.name = 'Volleyball';
#3
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
#4
SELECT students.name, students.class, sportgroups.location, coaches.name
FROM students
 JOIN student_sport ON students.id = student_sport.student_id 
 JOIN sportGroups ON student_sport.sportGroup_id = sportGroups.id
 JOIN coaches ON sportgroups.coach_id = coaches.id
WHERE sportclub.hourOftraining='8:00';

