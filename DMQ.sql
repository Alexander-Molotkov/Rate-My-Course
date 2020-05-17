----------------------------------
-- PROFILE PAGE
----------------------------------
-- Display Data
SELECT Authors.username, 
       Courses.courseTitle,
       Majors.majorTitle, 
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
    WHERE Authors.authorID = :authorIDInput;

-- Delete Profile
DELETE FROM Authors
    WHERE Authors.authorID = :authorIDInput;

-- Delete Review
DELETE FROM Reviews
    WHERE Reviews.reviewID = :reviewIDInput;

----------------------------------
-- COURSE PAGE
----------------------------------
-- Display Data
SELECT Courses.courseTitle,
       Colleges.collegeName, 
       Majors.majorTitle, 
       Reviews.reviewTitle,
       Reviews.difficultyRating,
       Reviews.workloadRating,
       Reviews.interestRating,
       Reviews.comments
       Authors.username, 
    FROM Authors
        INNER JOIN Reviews ON Authors.authorID = Reviews.authorID
        INNER JOIN Courses ON Reviews.courseID = Courses.courseID
        INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
        INNER JOIN Majors_Courses ON Courses.courseID = Majors_Courses.courseID
        INNER JOIN Majors ON Majors.majorID = Majors_Courses.majorID
    WHERE Courses.courseID = :courseIDInput;

-- Delete Course
DELETE FROM Courses
    WHERE Courses.courseID = :courseIDInput;

-- Delete Review
DELETE FROM Reviews
    WHERE Reviews.reviewID = :reviewIDInput;

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