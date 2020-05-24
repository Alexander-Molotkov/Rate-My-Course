var express    = require("express");
var mysql      = require("./dbcon.js");
var app        = express();
var bodyParser = require("body-parser");
var handlebars = require("express-handlebars").create({defaultLayout: "main"});

app.use(bodyParser.urlencoded({extended: true}));
app.engine("handlebars", handlebars.engine);
app.set("view engine", "handlebars");
app.set("port", 7005);

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
// PROFILE PAGE
// ----------------------------------------------

// READ ROUTE for profiles
app.get("/profile", function(req, res, next){
	var context = {};
	var queryString = `SELECT Authors.username, 
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
	WHERE Authors.authorID = 1
	GROUP BY Courses.courseID;`;
	mysql.pool.query(queryString, function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		context.rows = rows;
		console.log(context);
		res.render("profile", context);
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
