var async = require('async');
var fs = require('fs');
var json2mongo = require('json2mongo');

//Importing the required mongodb driver
var MongoClient = require('mongodb').MongoClient;
//MongoDB connection URL
var dbHost = 'mongodb://localhost:27017/rocketchat';

//Connecting to the Mongodb instance.
//Make sure your mongodb daemon mongod is running on port 27017 on localhost
MongoClient.connect(dbHost, function(err, db){
  if ( err ) throw err;
    // Removing rocketchat settings 
    db.collection("rocketchat_settings").remove({}, function(error, result){
        // Read settings json file
        fs.readFile('settings.json', 'utf8', function (err, data) {
            var json = JSON.parse(data);
            json = json2mongo(json);
            //Inserting settings. 
            db.collection("rocketchat_settings").insertMany(json, function(error, result){
                if(error) console.log(error);
                db.close()
                process.exit()
            });
        });   
    });   
});

