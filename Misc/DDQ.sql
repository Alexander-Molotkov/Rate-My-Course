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
    (1, 'Foo', 'Bar'),
    (2, 'Foo1', 'Bar1'),
    (3, 'Foo3', 'Bar2'),
    (4, 'Foo4', 'Bar2');
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
    (1, 'AZ_State', 'AZ'),
    (2, 'BC_State', 'BC'),
    (3, 'DC_State', 'DC'),
    (4, 'QW_State', 'QW');
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
    (1, 1, 'Math', 'foobar'),
    (2, 2, 'Social studies', 'barfoo'),
    (3, 3, 'PE', 'foobar'),
    (4, 4, 'Writing', 'barfoo'),
    (5, NULL, 'Writing', 'ProfessorX');
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
    (1, 1, 1, 'Rev1', 5, 3, 2, 'Comments for Rev1'),
    (2, 2, 2, 'Rev2', 6, 1, 2, 'Comments for Rev2'),
    (3, 3, 3, 'Rev3', 5, 5, 7, 'Comments for Rev3'),
    (4, 4, NULL, 'Rev4', 8, 1, 9, NULL);
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
        (1, 'major 1'),
        (2, 'major 2'),
        (3, 'major 3'),
        (4, 'major 4');
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
        (2, 3),
        (3, 2),
        (4, 4),
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
        (4, 1);
UNLOCK TABLES;