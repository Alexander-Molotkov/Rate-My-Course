var express        = require("express");
var mysql          = require("./dbcon.js");
var app            = express();
var bodyParser     = require("body-parser");
var handlebars     = require("express-handlebars").create({defaultLayout: "main"});
var methodOverride = require("method-override");

app.use(bodyParser.urlencoded({extended: true}));
app.engine("handlebars", handlebars.engine);
app.use(methodOverride('_method'));
app.set("view engine", "handlebars");
app.set("port", 4745);

// ----------------------------------------------
// HOME PAGE
// ----------------------------------------------

// READ ROUTE for main page
app.get("/", function(req, res, next){
	var context = {};
	var queryString = `SELECT * FROM Colleges;`;
	mysql.pool.query(queryString, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		context.rows = rows;
		console.log(context);
		res.render("home", context);
	});
});

// ----------------------------------------------
// SEARCH RESULTS PAGE
// ----------------------------------------------

// READ ROUTE for search results
app.get("/search", function(req, res, next){
	var context = {};
	var queryString = `SELECT Courses.courseID, 
		Courses.courseTitle, 
		Colleges.collegeName, 
		Colleges.state, 
		GROUP_CONCAT( Majors.majorTitle SEPARATOR ', ' ) as majorTitle
	FROM Courses
		INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
		INNER JOIN Majors_Courses ON Courses.courseID = Majors_Courses.courseID
		INNER JOIN Majors ON Majors_Courses.majorID = Majors.majorID
	WHERE 
		Colleges.collegeID = ${mysql.pool.escape(Number(req.query.collegeID))} 
		${req.query.majorTitle ? ' AND Majors.majorTitle LIKE ' + mysql.pool.escape('%' + req.query.majorTitle + '%'): ''} 
		${req.query.courseTitle ? ' AND Courses.courseTitle LIKE ' + mysql.pool.escape('%' + req.query.courseTitle + '%'): ''}
	GROUP BY Courses.courseID;`; 
		console.log(queryString);  // for debugging
	
	// Search Query 
	mysql.pool.query(queryString, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		context.query = req.query;
		context.rows = rows;
		// Query to get info from college selected
		mysql.pool.query('SELECT * FROM Colleges WHERE collegeID = ?', Number(req.query.collegeID), function(err,rows,fields){
			if(err){
				next(err);
				return;
			}
			context.college = rows;
			console.log(context);
			res.render("search", context);
		});
	});
});

// ----------------------------------------------
// COURSE PAGE
// ----------------------------------------------

// READ ROUTE for courses
app.get("/course/:id", function(req, res, next){
	var context = {};
	var queryStringCourse = `SELECT Courses.courseID, 
		Courses.courseTitle, 
		Colleges.collegeName, 
		Colleges.state
	FROM Courses
		INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
	WHERE 
		Courses.courseID = ${mysql.pool.escape(Number(req.params.id))};`;	
	var queryStringMajors = `SELECT * 
	FROM Majors 
		INNER JOIN Majors_Courses ON Majors.majorID = Majors_Courses.majorID
	WHERE
		Majors_Courses.courseID = ${mysql.pool.escape(Number(req.params.id))};`;
	var queryStringReviews = `SELECT Courses.courseTitle,
		Colleges.collegeName, 
		GROUP_CONCAT( Majors.majorTitle SEPARATOR ', ' ) as majorTitle, 
		Reviews.reviewTitle,
		Reviews.difficultyRating,
		Reviews.workloadRating,
		Reviews.interestRating,
		Reviews.comments,
		Authors.username,
		Authors.authorID 
	FROM Reviews
		LEFT JOIN Authors ON Authors.authorID = Reviews.authorID
		INNER JOIN Courses ON Reviews.courseID = Courses.courseID
		INNER JOIN Colleges ON Courses.collegeID = Colleges.collegeID
		INNER JOIN Majors_Courses ON Courses.courseID = Majors_Courses.courseID
		INNER JOIN Majors ON Majors.majorID = Majors_Courses.majorID
	WHERE Courses.courseID = ${mysql.pool.escape(Number(req.params.id))}
	GROUP BY Reviews.reviewID;`; 

	// Query for course information
	mysql.pool.query(queryStringCourse, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		context.course = rows;
		// Query for majors information
		mysql.pool.query(queryStringMajors, function(err, rows, fields){
			if(err){
				next(err);
				return;
			}
			context.majors = rows;
			// Query for reviews information
			mysql.pool.query(queryStringReviews, function(err, rows, fields){
				if(err){
					next(err);
					return;
				}
				context.rows = rows;
				console.log(context);
				res.render("course", context);
			});
		});
	});
});

// DELETE ROUTE for Majors_Courses
app.delete("/majorsCourses", function(req, res, next){
	var queryString = `DELETE FROM Majors_Courses
    WHERE 
        Majors_Courses.courseID = ${req.body.courseID} AND 
		Majors_Courses.majorID = ${req.body.majorID};`;
	
	console.log(queryString);
	mysql.pool.query(queryString, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		res.redirect("back");
	});
});

// ----------------------------------------------
// PROFILE PAGE
// ----------------------------------------------

// READ ROUTE for profiles
app.get("/profile/:id", function(req, res, next){
	var context = {};
	var queryString = `SELECT Authors.username, 
		Courses.courseID,
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
	WHERE Authors.authorID = ${Number(req.params.id)}
	GROUP BY Courses.courseID;`;

	// Query for reviews info
	mysql.pool.query(queryString, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		context.rows = rows;
		mysql.pool.query(`SELECT * FROM Authors WHERE authorID = ${Number(req.params.id)}`, function(err, rows, fields){
			if(err){
				next(err);
				return;
			}
			context.author = rows;
			console.log(context);
			res.render("profile", context);
		});
	});
});

// ----------------------------------------------
// REGISTER COLLEGE PAGE
// ----------------------------------------------

// READ ROUTE for Register College
app.get("/newcollege", function(req, res, next){
	res.render("newcollege");
});
// CREATE ROUTE for Colleges
app.post("/newcollege", function(req, res, next){
	var queryString = `INSERT INTO Colleges(collegeName, state)
	VALUES (?, ?);`;
	var newCollege = [req.body.collegeName, req.body.state];

	console.log(req.body);
	mysql.pool.query(queryString, newCollege, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		res.redirect("/");
	});
});

// ----------------------------------------------
// SIGNUP PAGE
// ----------------------------------------------

// READ ROUTE for Signup
app.get("/signup", function(req, res, next){
	res.render("signup");
});
// CREATE ROUTE for Signup
app.post("/signup", function(req, res, next){
	var queryString = `INSERT INTO Authors(username, password) VALUES (?, ?);`;
	var newAuthor = [req.body.username, req.body.password];

	console.log(req.body);
	mysql.pool.query(queryString, newAuthor, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		res.redirect("/");
	});
});

// ----------------------------------------------
// ERROR HANDLING
// ----------------------------------------------
app.use(function (req, res) {
	res.status(404);
	res.render("404");
});

app.use(function (err, req, res, next) {
	console.error(err.stack);
	res.status(500);
	res.render("500");
});

app.listen(app.get("port"), function () {
	console.log("Express started on http://flip2.engr.oregonstate.edu:" +
			app.get("port") +
			"; press Ctrl-C to terminate.");
});
