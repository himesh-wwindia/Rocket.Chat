//Note:
// Install async and mongodb package 
// npm install async  
// npm install mongodb  
			
var async = require('async');
//Importing the required mongodb driver
var MongoClient = require('mongodb').MongoClient;

//MongoDB connection URL
var dbHost = 'mongodb://localhost:27017/rocketchat';

//Name of the collection
var myCollection = "users";

//Connecting to the Mongodb instance.
//Make sure your mongodb daemon mongod is running on port 27017 on localhost
MongoClient.connect(dbHost, function(err, db){
  if ( err ) throw err;

	async.series([
		function(callback) {
		    //Query Mongodb and add seperate UserId, profileType, profileURL, SubscriptionCode fields into the customFields.
			db.collection(myCollection).find().snapshot().forEach(
			    function (elem) {
			        db.collection(myCollection).update(
			            {
			                _id: elem._id
			            },
			            {
			                $set: {
			                    "customFields": {
			                    "UserId": elem.UserId,
			                    "profileURL": elem.profileURL,
			                    "profileType": elem.profileType,
			                    "SubscriptionCode":elem.SubscriptionCode
			                    }
			                }
			            }
			        );
			    }
			);
		    
		    callback(null, 'done');
		},
		function(callback) {
		    // Removing seperate fields UserId, UserId, profileType and SubscriptionCode from all documents.
		    db.collection(myCollection).update({}, {$unset: {UserId:"",UserId:"",profileType:"", SubscriptionCode: ""}},{multi: true});
		    
		    callback(null, 'done');
		}
	],
	function(err, results) {
	    db.close()
	    process.exit()
	});
});
