// Note:
// Install async and mongodb package 
// npm install async  
// npm install mongodb  
			
var async = require('async');
//Importing the required mongodb driver
var MongoClient = require('mongodb').MongoClient;

//MongoDB connection URL
var dbHost = 'mongodb://localhost:27017/rocketchat';

//Connecting to the Mongodb instance.
//Make sure your mongodb daemon mongod is running on port 27017 on localhost
MongoClient.connect(dbHost, function(err, db){
  if ( err ) throw err;
	async.series([
		function(callback) {
           // Removing all users
           db.collection("users").remove({}, function(error, result){
		       callback(null, 'done');
           });
		},
		function(callback) {
		    // Removing all groups.
            db.collection("rocketchat_room").remove({}, function(error, result){
		       callback(null, 'done');
           });
		},
		function(callback) {
		    // Removing all user subscription from groups.
            db.collection("rocketchat_subscription").remove({}, function(error, result){
		       callback(null, 'done');
           });
		},
		function(callback) {
		    // Removing all messages.
   		   db.collection("rocketchat_message").remove({}, function(error, result){
		       callback(null, 'done');
           });
		}
	],
	function(err, results) {
	    db.close()
	    process.exit()
	});
});

