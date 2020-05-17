--------------------------------
-- MAJORS
--------------------------------

-- Create Table
DROP TABLE IF EXISTS `Majors`;
CREATE TABLE `Majors`
(
    `majorID` int(11) NOT NULL AUTO_INCREMENT,
    `majorTitle` varchar(51) NOT NULL,
    PRIMARY KEY(`majorID`),
    CONSTRAINT `uniqueMajorID`     UNIQUE (`majorID`),
    CONSTRAINT `uniqueMajorTitle`  UNIQUE (`majorTitle`)
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Majors` WRITE;
INSERT INTO Majors(majorTitle)
    VALUES
        ('major 1'),
        ('major 2'),
        ('major 3'),
        ('major 4');
UNLOCK TABLES;

--------------------------------
-- MAJORS_COURSES - Needs to be executed after Majors and Courses are created
--------------------------------

-- Create Table
DROP TABLE IF EXISTS `Majors_Courses`;
CREATE TABLE `Majors_Courses`
(
    `majorID` int(11) NOT NULL,
    `courseID` int(11) NOT NULL,
    PRIMARY KEY(`majorID`,`courseID`),
    CONSTRAINT `Majors_Courses_FK1`
        FOREIGN KEY (`majorID`)
        REFERENCES `Majors`(`majorID`),
    CONSTRAINT `Majors_Courses_FK2`
        FOREIGN KEY (`courseID`)
        REFERENCES `Courses`(`courseID`),
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Majors_Courses` WRITE;
INSERT INTO `Majors`(`majorID`, `courseID`)
    VALUES
        (1, 1),
        (2, 3),
        (3, 2),
        (4, 4),
        (4, 1);
UNLOCK TABLES;

--------------------------------
-- COLLEGES_MAJORS - Needs to be executed after Colleges and Majors are created
--------------------------------

-- Create Table
DROP TABLE IF EXISTS `Colleges_Majors`;
CREATE TABLE `Colleges_Majors`
(
    `majorID` int(11) NOT NULL,
    `collegeID` int(11) NOT NULL,
    PRIMARY KEY(`majorID`,`collegeID`),
    CONSTRAINT `Colleges_Majors_FK1`
        FOREIGN KEY (`majorID`)
        REFERENCES `Majors`(`majorID`),
    CONSTRAINT `Colleges_Majors_FK2`
        FOREIGN KEY (`collegeID`)
        REFERENCES `Colleges`(`collegeID`),
) ENGINE=InnoDB;

-- Sample Data
LOCK TABLES `Colleges_Majors` WRITE;
INSERT INTO `Colleges_Majors`(`majorID`, `collegeID`)
    VALUES
        (1, 1),
        (2, 3),
        (3, 2),
        (4, 4),
        (4, 1);
UNLOCK TABLES;