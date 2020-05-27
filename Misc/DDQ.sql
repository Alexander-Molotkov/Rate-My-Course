-- *********************************
-- AUTHORS
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Authors`;
CREATE TABLE `Authors`
(
    `authorID` int(11) NOT NULL AUTO_INCREMENT, 
    `username` varchar(16) NOT NULL,
	`password` varchar(21) NOT NULL,
    PRIMARY KEY(`authorID`),
    CONSTRAINT `authors_uniqueUsername` UNIQUE (`username`)
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Authors` WRITE;
INSERT INTO `Authors`
VALUES 
    (1, 'Claude', 'password'),
    (2, 'Alethea', 'password'),
    (3, 'Malcolm', 'password'),
    (4, 'Chantel', 'password'),
    (5, 'Oda', 'password'),
    (6, 'Tyree', 'password'),
    (7, 'Larue', 'password'),
    (8, 'Janell', 'password');
UNLOCK TABLES;

-- *********************************
-- COLLEGES
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Colleges`;
CREATE TABLE `Colleges`
(
    `collegeID` int(11) NOT NULL AUTO_INCREMENT, 
    `collegeName` varchar(255) NOT NULL,
	`state` varchar(30) NOT NULL,
    PRIMARY KEY (`collegeID`)
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Colleges` WRITE;
INSERT INTO `Colleges`
VALUES 
    (1, 'Skyline College', 'AL'),
    (2, 'Mammoth College', 'FL'),
    (3, 'Sunny Coast College', 'HI'),
    (4, 'Fortuna College', 'KY');
UNLOCK TABLES;

-- *********************************
-- COURSES
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Courses`;
CREATE TABLE `Courses`
(
    `courseID` int(11) NOT NULL AUTO_INCREMENT, 
    `collegeID` int(11) NOT NULL,
	`courseTitle` varchar(50) NOT NULL,
	`professor` varchar(30) NOT NULL,
    PRIMARY KEY(`courseID`),
    KEY `collegeID` (`collegeID`),
    CONSTRAINT `reviews_collegeID_FK`   
        FOREIGN KEY (`collegeID`) 
        REFERENCES `Colleges`(`collegeID`)
            ON UPDATE CASCADE
            ON DELETE CASCADE
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Courses` WRITE;
INSERT INTO `Courses`
VALUES 
    (1, 1, 'Math', 'Nicola Roberto'),
    (2, 2, 'Social studies', 'Adrien Josephson'),
    (3, 3, 'PE', 'Sherman Yohe'),
    (4, 4, 'Writing', 'Celina Huckabee'),
    (5, 1, 'Magic Infusion', 'Lawanda Cann'),
    (6, 1, 'Galactic Business', 'Barbie Tardy'),
    (7, 1, 'Planetary History', 'Afton Hayward'),
    (8, 1, 'Writing', 'Hyacinth Ruzicka'),
    (9, 3, 'Math', 'Chasidy Peckham'),
    (10, 1, 'PE', 'Rod Hage'),
    (11, 4, 'Social studies', 'Seth Alequin'),
    (12, 1, 'Intro to Databases', 'Lola Drennen'),
    (13, 2, 'Intro to Databases', 'Janet Hedlund'),
    (14, 3, 'Intro to Databases', 'Marie Gerry'),
    (15, 4, 'Intro to Databases', 'Tillie Saidi');
UNLOCK TABLES;

-- *********************************
-- REVIEWS
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Reviews`;
CREATE TABLE `Reviews`
(
    `reviewID` int(11) NOT NULL AUTO_INCREMENT, 
    `courseID` int(11) NOT NULL, 
    `authorID` int(11),
    `reviewTitle` varchar(50) NOT NULL,
    `difficultyRating` int(11) NOT NULL,
    `workloadRating` int(11) NOT NULL,
    `interestRating` int(11) NOT NULL,
    `comments` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`reviewID`),
    KEY `courseID` (`courseID`),
    KEY `authorID` (`authorID`),
    CONSTRAINT `reviews_courseID_FK`    
        FOREIGN KEY (`courseID`) 
        REFERENCES `Courses`(`courseID`)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    CONSTRAINT `reviews_authorID_FK`
        FOREIGN KEY (`authorID`) 
        REFERENCES `Authors`(`authorID`)
            ON UPDATE CASCADE
            ON DELETE SET NULL
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Reviews` WRITE;
INSERT INTO `Reviews`
VALUES 
    (1, 1, 1, 'premium', 10, 7, 4, 'This beautifully written story with an intriguing plot and lovable characters. I’m only sad that it had to end.'),
    (2, 2, 2, 'light', 9, 3, 4, "School is learning things you don't want to know, surrounded by people you wish you didn't know, while working toward a future you don't know will ever come."),
    (3, 3, 3, 'polite', 5, 5, 7, "The most important thing we learn at school is the fact that the most important things can't be learned at school."),
    (4, 4, 4, 'wakeful', 7, 4, 10, "In school they told me Practice makes perfect. And then they told me Nobody's perfect, so then I stopped practicing."),
    (5, 1, 5, 'true', 5, 5, 7, "We all learn by experience but some of us have to go to summer school."),
    (6, 2, 6, 'psychedelic', 3, 8, 1, "You can drag my body to school but my spirit refuses to go."),
    (7, 3, 7, 'sweet', 5, 5, 7, "As long as teachers give tests, there will always be prayer in schools."),
    (8, 4, 8, 'dynamic', 7, 6, 8, "A man who has never gone to school may steal from a freight car; but if he has a university education, he may steal the whole railroad."),
    (9, 5, 1, 'bumpy', 8, 1, 5, "There are only two places in the world where time takes precedence over the job to be done: school and prison."),
    (10, 6, 2, 'capricious', 10, 10, 2, "School is one long illness with symptoms that switch every five minutes so you think it's getting better or worse. But really it's the same thing for years and years."),
    (11, 7, 3, 'silent', 7, 10, 8, "As long as algebra is taught in school, there will be prayer in school."),
    (12, 8, 4, 'tiresome', 6, 9, 7, "If there were no schools to take the children away from home part of the time, the insane asylums would be filled with mothers."),
    (13, 9, 5, 'comfortable', 10, 5, 5, "School is practice for future life, practice makes perfect and nobody's perfect, so why practice?"),
    (14, 10, 6, 'ad hoc', 8, 4, 9, "In school one learns to ask stupid questions of life."),
    (15, 11, 7, 'therapeutic', 5, 8, 4, "School is the advertising agency which makes you believe that you need the society as it is."),
    (16, 12, 8, 'outstanding', 10, 10, 10, "The trouble with school is they give you the answer, then they give you the exam. That's not life...."),
    (17, 13, NULL, 'heavy', 10, 10, 10, "No school without spectacular eccentrics and crazy hearts is worth attending."),
    (18, 14, NULL, '=)', 10, 1, 10, "No Comment");
UNLOCK TABLES;

-- *********************************
-- MAJORS
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Majors`;
CREATE TABLE `Majors`
(
    `majorID` int(11) NOT NULL AUTO_INCREMENT,
    `majorTitle` varchar(51) NOT NULL,
    PRIMARY KEY(`majorID`),
    CONSTRAINT `uniqueMajorTitle`  UNIQUE (`majorTitle`)
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Majors` WRITE;
INSERT INTO `Majors`
    VALUES
        (1, 'Wizardry'),
        (2, 'Politics'),
        (3, 'Adulting'),
        (4, 'Undeclared');
UNLOCK TABLES;

-- *********************************
-- MAJORS_COURSES - Needs to be executed after Majors and Courses are created
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Majors_Courses`;
CREATE TABLE `Majors_Courses`
(
    `majorID` int(11) NOT NULL,
    `courseID` int(11) NOT NULL,
    PRIMARY KEY(`majorID`,`courseID`),
    KEY `courseID` (`courseID`),
    CONSTRAINT `Majors_Courses_FK1`
        FOREIGN KEY (`majorID`)
        REFERENCES `Majors`(`majorID`)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    CONSTRAINT `Majors_Courses_FK2`
        FOREIGN KEY (`courseID`)
        REFERENCES `Courses`(`courseID`)            
            ON UPDATE CASCADE
            ON DELETE CASCADE
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Majors_Courses` WRITE;
INSERT INTO `Majors_Courses`
    VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (1, 5),
        (2, 6),
        (3, 7),
        (4, 8),
        (1, 9),
        (2, 10),
        (3, 11),
        (4, 12),
        (1, 13),
        (1, 14),
        (2, 15),
        (2, 1),
        (3, 2),
        (3, 10),
        (4, 1);
UNLOCK TABLES;

-- *********************************
-- COLLEGES_MAJORS - Needs to be executed after Colleges and Majors are created
-- *********************************

-- Create Table
DROP TABLE IF EXISTS `Colleges_Majors`;
CREATE TABLE `Colleges_Majors`
(
    `majorID` int(11) NOT NULL,
    `collegeID` int(11) NOT NULL,
    PRIMARY KEY(`majorID`,`collegeID`),
    KEY `collegeID` (`collegeID`),
    CONSTRAINT `Colleges_Majors_FK1`
        FOREIGN KEY (`majorID`)
        REFERENCES `Majors`(`majorID`)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    CONSTRAINT `Colleges_Majors_FK2`
        FOREIGN KEY (`collegeID`)
        REFERENCES `Colleges`(`collegeID`)
            ON UPDATE CASCADE
            ON DELETE CASCADE
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Colleges_Majors` WRITE;
INSERT INTO `Colleges_Majors`
    VALUES
        (1, 1),
        (2, 3),
        (3, 2),
        (4, 4),
        (1, 4),
        (2, 2),
        (3, 3),
        (4, 3),
        (1, 2);
UNLOCK TABLES;