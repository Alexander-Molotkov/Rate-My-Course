--Step A

--*********
--Authors
--*********
DROP TABLE IF EXISTS `Authors`;
CREATE TABLE `Authors` (
    `authorID`         int(11) NOT NULL AUTO_INCREMENT, 
    `username`         varchar(16) NOT NULL,
	`password`         varchar(21) NOT NULL,
    PRIMARY KEY (`authorID`),
    CONSTRAINT `authors_uniqueAuthorID` UNIQUE(authorID),
    CONSTRAINT `authors_uniqueUsername` UNIQUE(username)
) ENGINE=InnoDB;

--**********
--Colleges
--**********
DROP TABLE IF EXISTS `Colleges`;
CREATE TABLE `Colleges` (
    `collegeID`        int(11) NOT NULL AUTO_INCREMENT, 
    `collegeName`      varchar(30) NOT NULL,
	`state`            varchar(30) NOT NULL,
    PRIMARY KEY (`collegeID`),
    CONSTRAINT `courses_uniqueCollegeID` UNIQUE(collegeID)
) ENGINE=InnoDB;

--*********
--Courses
--*********
DROP TABLE IF EXISTS `Courses`;
CREATE TABLE `Courses` (
    `courseID`         int(11) NOT NULL AUTO_INCREMENT, 
    `collegeID`        int(11),
	`courseTitle`      varchar(50) NOT NULL,
	`professor`        varchar(30) NOT NULL,
    PRIMARY KEY (`courseID`),
    CONSTRAINT `courses_uniqueCourseID` UNIQUE(courseID),
    CONSTRAINT `reviews_collegeID_FK`   FOREIGN KEY (`collegeID`) REFERENCES `Colleges`(`collegeID`)
) ENGINE=InnoDB;

--*********
--Reviews
--*********
DROP TABLE IF EXISTS `Reviews`;
CREATE TABLE `Reviews` (
    `reviewID`         int(11) NOT NULL AUTO_INCREMENT, 
    `courseID`         int(11), 
    `authorID`         int(11),
    `reviewTitle`      varchar(50) NOT NULL,
    `difficultyRating` int(11) NOT NULL,
    `workloadRating`   int(11) NOT NULL,
    `interestRating`   int(11) NOT NULL,
    PRIMARY KEY (`reviewID`),
    CONSTRAINT `reviews_uniqueReviewID` UNIQUE(reviewID),
    CONSTRAINT `reviews_courseID_FK`    FOREIGN KEY (`courseID`) REFERENCES `Courses`(`courseID`),
    CONSTRAINT `reviews_authorID_FK`    FOREIGN KEY (`authorID`) REFERENCES `Authors`(`authorID`)
) ENGINE=InnoDB;

--//////////////////
--      STEP B
--//////////////////

--*********
--Authors
--*********

LOCK TABLES `Authors` WRITE;
INSERT INTO Authors(username, password)
VALUES 
    ('Foo', 'Bar'),
    ('Foo1', 'Bar1'),
    ('Foo3', 'Bar2'),
    ('Foo4', 'Bar2');
UNLOCK TABLES;

--**********
--Colleges
--**********

LOCK TABLES `Colleges` WRITE;
INSERT INTO Colleges(collegeName, state)
VALUES 
    ('AZ_State', 'AZ'),
    ('BC_State', 'BC'),
    ('DC_State', 'DC'),
    ('QW_State', 'QW');
UNLOCK TABLES;

--*********
--Courses
--*********

--Explicit definition of CollegeID should be replaced with a query to `Colleges`.
LOCK TABLES `Courses` WRITE;
INSERT INTO Courses(collegeID, courseTitle, professor)
VALUES 
    ('1', 'Math', 'foobar'),
    ('2', 'Social studies', 'barfoo'),
    ('3', 'PE', 'foobar'),
    ('4', 'Writing', 'barfoo');
UNLOCK TABLES;

--*********
--Reviews
--*********

--Explicit definition of courseID and authorID should be replaced with queries
--  to `Courses` and `Authors`.
LOCK TABLES `Reviews` WRITE;
INSERT INTO Reviews(courseID, authorID, reviewTitle, difficultyRating, workloadRating, interestRating)
VALUES 
    ('1', '37', 'Rev1', '5', '3', '2'),
    ('2', '38', 'Rev2', '6', '1', '2'),
    ('3', '39', 'Rev3', '5', '5', '7'),
    ('4', '40', 'Rev4', '8', '1', '9');
UNLOCK TABLES;

-- http://web.engr.oregonstate.edu/~molotkoa/

----------------------------------------------------------------------------------

--*********
--Authors
--*********

--Find author
SELECT * FROM `Authors`
WHERE username = :username AND password = :password;

--New author
INSERT INTO `Authors`(username, password)
VALUES (:username, :password);

--Change password
UPDATE `Authors`
SET password = :newPassword
where username = :username;

--Delete profile
DELETE FROM `Authors`
WHERE `username` = :username;

--**********
--Colleges
--**********

--Find college
SELECT * from `Colleges`
WHERE collegeName = :collegeName AND state = :state;

--New college
INSERT INTO `Colleges`(collegeName, State)
VALUES (:collegeName, :state);

--Remove college
DELETE FROM `Colleges`
WHERE `collegeName` = :collegeName;

--*********
--Courses
--*********

--Find course
SELECT * from `Courses`
WHERE `collegeID` = :collegeID AND courseTitle = :courseTitle AND professor = :professor;

--New course
INSERT INTO `Courses`(collegeID, courseTitle, professor)
VALUES (:collegeID, :courseTitle, :professor)

--*********
--Reviews
--*********

--Find review based on course
SELECT * from `Reviews`
WHERE `courseID` = :courseID

--Find review based on author
SELECT * from `Reviews`
WHERE `authorID` = :authorID

--New review
INSERT INTO `Reviews`(courseID, authorID, reviewTitle, difficultyRating, workloadRating, interestRating)
VALUES (:courseID, :authorID, :reviewTitle, :difficultyRating, :workloadRating, :interestRating);

--Edit review
UPDATE `Reviews`
SET (reviewTitle =      :reviewTitle, 
     difficultyRating = :difficultyRating,
     workloadRating =   :workloadRating, 
     interestRating =   :interestRating)
WHERE reviewID = :reviewID;

--Delete author from review
UPDATE `Reviews`
SET authorID = Null
where reviewID = :reviewID;

--Delete a review
DELETE from `Reviews` 
WHERE reviewID = :reviewID
