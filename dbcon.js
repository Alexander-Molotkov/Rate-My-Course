var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_cortesn',
  password        : '0270',
  database        : 'cs340_cortesn'
});

module.exports.pool = pool;
