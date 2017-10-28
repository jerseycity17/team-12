var admin = require("firebase-admin");
var twilio = require('twilio');
var fs = require('fs');

// Initialize the app with a service account, granting admin privileges
admin.initializeApp({
  credential: admin.credential.cert("rescue-sec-sa.json"),
  databaseURL: "https://rescue-sec.firebaseio.com"
});

// As an admin, the app has access to read and write all data, regardless of Security Rules
var db = admin.database();

var rootRef = db.ref();

var accountSid = 'AC6a5533386b6621270cf5a57c3b2c1b42'; // Your Account SID from www.twilio.com/console
var authToken = '730567e063a28debdf69c6d5c0f28a21';

var client = new twilio(accountSid, authToken);

// Create a new user
function createUser(userId, firstName, lastName, email, contacts, title, locations, region, country, field){
    db.ref('users/' + userId).set({
      firstName: firstName,
      lastName: lastName,
      email: email,
      contacts: {
        cell: contacts[0],
        home: contacts[1],
        office: contacts[2]
      },
      title: title,
      locations: {
        current: locations[0],
        home: locations[1],
        previous: locations[2]
      },
	  office: region + ',' + country + ',' + field
    });
}

function setUserLocations(userId, locations) {
	db.ref('users/' + userId + '/locations').set({
		current: locations[0],
		home: locations[1],
		previous: locations[2]
	});
}

function setUserCurrLocation(userId, loc) {
	db.ref('users/' + userId + '/locations/current').set(loc);
}

function setUserHomeLocation(userId, loc) {
	db.ref('users/' + userId + '/locations/home').set(loc);
}

function setUserPreviousLocation(userId, loc) {
	db.ref('users/' + userId + '/locations/previous').set(loc);
}

function getUserCurrLocation(userId) {
	var loc = 'None';
	
	var ref = db.ref('users/' + userId + '/locations');
	ref.on('value', function(snapshot) {
		loc = snapshot.val().current || 'None';
	});
	
	return loc;
}

function getUserHomeLocation(userId) {
	var loc = 'None';
	
	var ref = db.ref('users/' + userId + '/locations');
	ref.on('value', function(snapshot) {
		loc = snapshot.val().home || 'None';
	});
	
	return loc;
}

function getUserPreviousLocation(userId) {
	var loc = 'None';
	
	var ref = db.ref('users/' + userId + '/locations');
	ref.on('value', function(snapshot) {
		loc = snapshot.val().previous || 'None';
	});
	
	return loc;
}

function sendMessage(mtxt, toNum, fromNum) {
	client.messages.create({
		body: mtxt,
		to: '+' + toNum,  // Text this number
		from: '+' + fromNum // From a valid Twilio number
	}).then((message) => console.log(message.sid));
}

var userId = 123456789;
createUser(userId, "John", "Smith", "test@example.com", [1,2,3],"test", ["1,-1","2,-2","3,-3"], "US", "NY", "New York");
var currLoc = getUserCurrLocation(userId);
var homeLoc = getUserHomeLocation(userId);
var previousLoc = getUserPreviousLocation(userId);
console.log(currLoc);
console.log(homeLoc);
console.log(previousLoc);
//sendMessage('no', '19086037936', '19042043485');
