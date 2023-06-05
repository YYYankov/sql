DROP DATABASE IF EXISTS movie_theaters;
CREATE DATABASE movie_theaters;
USE movie_theaters;

CREATE TABLE Cinema (
  cinema_id INT AUTO_INCREMENT PRIMARY KEY ,
  cinemaName VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL
);

CREATE TABLE Movies(
movie_id INT AUTO_INCREMENT PRIMARY KEY,
movieName VARCHAR(255) NOT NULL,
orig VARCHAR(255) NOT NULL,
year DATE
);

CREATE TABLE Halls (
  hall_id INT AUTO_INCREMENT PRIMARY KEY,
  cinema_id INT NOT NULL,
  hallNumber VARCHAR(255) NOT NULL,
  hallStatus ENUM('VIP', 'Deluxe', 'Normal'),
  FOREIGN KEY (cinema_id) REFERENCES Cinema(cinema_id)
);

CREATE TABLE Projection(
proj_id INT AUTO_INCREMENT PRIMARY KEY,
movie_id INT NOT NULL,
hall_id INT NOT NULL,
startTime TIME,
vis_num INT NOT NULL,
FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
FOREIGN KEY (hall_id) REFERENCES Halls(hall_id)
);

INSERT INTO Cinema
VALUES 	(NULL, 'KINO 1', 'Sofia') ,
		(NULL, 'KINO 2', 'Sofia') ,
		(NULL, 'Arena Mladost', 'Sofia');
        
        
INSERT INTO Halls
VALUES 	(NULL, '1',  '100', 'VIP') ,
		(NULL, '1', '100', 'Deluxe') ,
		(NULL, '1','100', 'VIP') ,
		(NULL, '1', '100', 'Normal') ,
		(NULL, '1', '100', 'Deluxe');
        
        
SELECT c.cinemaName, h.hallNumber, p.startTime
FROM Cinema c
INNER JOIN Halls h ON c.cinema_id = h.cinema_id
INNER JOIN Projection p ON h.hall_id = p.hall_id
INNER JOIN Movies m ON p.movie_id = m.movie_id
WHERE m.movieName = 'Final Destination 7'
AND h.hallStatus IN ('VIP', 'Deluxe')
ORDER BY c.cinemaName, h.hallNumber;

SELECT SUM(p.vis_num) AS total_viewers
FROM cinema c
INNER JOIN Halls h ON c.cinema_id = h.cinema_id
INNER JOIN Projection p ON h.hall_id = p.hall_id
INNER JOIN Movies m ON m.movie_id = m.movie_id
WHERE m.movieName = 'Final Destination 7'
AND h.hallStatus = 'VIP'
AND c.cinemaName = 'Arena Mladost';


