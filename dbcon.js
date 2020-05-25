var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_molotkoa',
  password        : '5696',
  database        : 'cs340_molotkoa'
});

module.exports.pool = pool;
