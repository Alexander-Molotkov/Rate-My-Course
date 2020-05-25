----------------------------------
-- SEARCH FOR A COURSE
----------------------------------
-- Populate College dropdown
SELECT * FROM Colleges

-- Search Results
SELECT Courses.courseID, 
       Courses.courseTitle, 
       Colleges.collegeName, 
       Colleges.state, 
       GROUP_CONCAT( Majors.majorTitle SEPARATOR ', ' ) as majorTitle
    FROM Courses
        INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
        INNER JOIN Majors_Courses ON Courses.courseID = Majors_Courses.courseID
        INNER JOIN Majors ON Majors_Courses.majorID = Majors.majorID
    WHERE collegeID = :collegeID AND courseTitle LIKE :courseTitle AND majorTitle LIKE :majorTitle; 

----------------------------------
-- PROFILE PAGE
----------------------------------
-- Display Data
SELECT Authors.username, 
       Courses.courseTitle,
       GROUP_CONCAT( Majors.majorTitle SEPARATOR ', ' ) as majorTitle, 
       Colleges.collegeName, 
       Reviews.reviewTitle,
       Reviews.difficultyRating,
       Reviews.workloadRating,
       Reviews.interestRating,
       Reviews.comments
    FROM Authors
        INNER JOIN Reviews ON Authors.authorID = Reviews.authorID
        INNER JOIN Courses ON Reviews.courseID = Courses.courseID
        INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
        INNER JOIN Majors_Courses ON Courses.courseID = Majors_Courses.courseID
        INNER JOIN Majors ON Majors.majorID = Majors_Courses.majorID
    WHERE Authors.authorID = :authorIDInput
    GROUP BY Courses.courseID;

-- Change password
UPDATE Authors
SET Authors.password = :newPassword
WHERE Authors.authorID = :authorIDInput;

-- Delete Profile
DELETE FROM Authors
    WHERE Authors.authorID = :authorIDInput;

-- Delete Review
DELETE FROM Reviews
    WHERE Reviews.reviewID = :reviewIDInput;

-- Edit review
UPDATE Reviews
SET (
    Reviews.reviewTitle      = :reviewTitle, 
    Reviews.difficultyRating = :difficultyRating,
    Reviews.workloadRating   = :workloadRating, 
    Reviews.interestRating   = :interestRating
    )
WHERE Reviews.reviewID = :reviewID;

--Delete author from review
UPDATE Reviews
SET Reviews.authorID = Null
where Reviews.reviewID = :reviewID;

----------------------------------
-- COURSE PAGE
----------------------------------
-- Display Data
SELECT Courses.courseTitle,
       Colleges.collegeName, 
       GROUP_CONCAT( Majors.majorTitle SEPARATOR ', ' ) as majorTitle, 
       Reviews.reviewTitle,
       Reviews.difficultyRating,
       Reviews.workloadRating,
       Reviews.interestRating,
       Reviews.comments,
       Authors.username 
    FROM Reviews
        LEFT JOIN Authors ON Authors.authorID = Reviews.authorID
        INNER JOIN Courses ON Reviews.courseID = Courses.courseID
        INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
        INNER JOIN Majors_Courses ON Courses.courseID = Majors_Courses.courseID
        INNER JOIN Majors ON Majors.majorID = Majors_Courses.majorID
    WHERE Courses.courseID = :courseIDInput
    GROUP BY Reviews.reviewID;

-- Delete Course
DELETE FROM Courses
    WHERE Courses.courseID = :courseIDInput;

-- Delete Review
DELETE FROM Reviews
    WHERE Reviews.reviewID = :reviewIDInput;

-- Edit review
UPDATE Reviews
SET
(
    Reviews.reviewTitle      = :reviewTitle, 
    Reviews.difficultyRating = :difficultyRating,
    Reviews.workloadRating   = :workloadRating, 
    Reviews.interestRating   = :interestRating
    )
WHERE Reviews.reviewID = :reviewID;

----------------------------------
-- REGISTER NEW COLLEGE
----------------------------------
INSERT INTO Colleges(collegeName, state)
    VALUES :collegeNameInput, :stateInput;

----------------------------------
-- CREATE REVIEW
----------------------------------
INSERT INTO Reviews(reviewTitle, difficultyRating, workloadRating, interestRating, comments)
    VALUES :collegeNameInput, :stateInput;

INSERT INTO Majors_Courses(courseID, majorID)
    VALUES :courseIDInput, :majorIDInput;
    WHERE NOT EXISTS (
        SELECT * 
        FROM Majors_Courses
        WHERE courseID = :courseIDInput AND majorID = :majorIDInput 
    );

INSERT INTO Colleges_Majors(collegeID, majorID)
    VALUES :collegeIDInput, :majorIDInput;
    WHERE NOT EXISTS (
        SELECT * 
        FROM Colleges_Majors
        WHERE collegeID = :collegeIDInput AND majorID = :majorIDInput 
    );