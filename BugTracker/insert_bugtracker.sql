INSERT INTO qas (name, email) VALUES
('Ivan Ivanov', 'ivanov@example.com'),
('Yanko Yankov', 'yankov@example.com'),
('Ivan Petkov', 'petkov@example.com');

INSERT INTO complexities (rarity) VALUES
('Low'),
('Medium'),
('High'),
('Critical');

INSERT INTO devs (name, role, email) VALUES
('Georgi Georgiev', 'Manager', 'georgiev@example.com'),
('Hristo Petrov', 'PO', 'petrov@example.com'),
('Emily Emily', 'Developer', 'emily@example.com'),
('Frank Sinatra', 'Developer', 'frank@example.com');

INSERT INTO projects (descr, id_manager, id_po) VALUES
('Project A', 1, 2),
('Project B', 1, 2);

INSERT INTO project_devs (id_project, id_dev) VALUES
(1, 3),
(1, 4),
(2, 3),
(2, 4);

INSERT INTO project_qas (id_project, id_qas) VALUES
(1, 1),
(2, 2);

INSERT INTO bugs (descr, priority, status, logged_time, logs, id_project, id_complex) VALUES
('Bug 1 in Project A', 'minor', 'new', '2022-01-01 00:00:00', 'Log of bug 1', 1, 1),
('Bug 2 in Project A', 'major', 'addressed', '2022-02-01 00:00:00', 'Log of bug 2', 1, 2),
('Bug 3 in Project B', 'critical', 'failed', '2022-03-01 00:00:00', 'Log of bug 3', 2, 3),
('Bug 4 in Project B', 'medium', 'closed', '2022-04-01 00:00:00', 'Log of bug 4', 2, 4);

INSERT INTO attachments (attachment_id, bug_id, dev_id, attachment_filename, attachment_size, attachment_type) VALUES
(1, 1, 3, 'attachment1.txt', 100, 'text/plain'),
(2, 1, 4, 'attachment2.jpg', 200, 'image/jpeg'),
(3, 2, 3, 'attachment3.png', 300, 'image/png');