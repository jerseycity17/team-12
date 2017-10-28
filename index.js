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

// Create new safety check (Send notifications, etc.)
function createSafetyChecks(region_name, vector) {
	var rootRef = db.ref();
	var storesRef = rootRef.child('safety checks/regions/' + region_name + '/');
	var newStoreRef = storesRef.push();
	newStoreRef.set({
		message: vector[0],
		title: vector[1],
		didCheck: vector[2]
	})
};

// Create new zone safety notification
function createZoneSafety(region_name, vector) {
	var rootRef = db.ref();
	var storesRef = rootRef.child('important zones/regions/' + region_name + '/');
	var newStoreRef = storesRef.push();
	newStoreRef.set
	({
		dangerLevel: vector[0],
		lattitude: vector[1],
		longitude: vector[2]
	})
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

// Remove user data
function removeUser(userId) {
	var to_remove = db.ref('users/' + userId);
	to_remove.remove();         
}

function createOffice(region, country, fieldOffice, location) {
  db.ref('offices/' + region + '/' + country + '/' + fieldOffice).set({
    region: region,
    country: country,
    fieldOffice: fieldOffice,
    location: location
  });
}

function addContact(region, country, fieldOffice, location, type, contact) {
  db.ref('offices/' + region + '/' + country + '/' + fieldOffice + '/contacts/' + type).push(contact);
}

// Create a new office
createOffice('US','NY','New York','loc_holder');
// Add contacts: emergency, medical, security
addContact('US','NY','New York','loc_holder','emergency',8006005000);

// Test Code
createZoneSafety("europe", ["Cautious", "40.732530", "-74.034556"]);
createZoneSafety("europe", ["Safe", "40.731415", "-74.039054"]);
createZoneSafety("europe", ["Dangerous", "40.732269", "-74.032400"]);
createZoneSafety("europe", ["Safe", "40.729997", "-74.031966"]);
createZoneSafety("europe", ["Cautious", "40.727891", "-74.032084"]);
createZoneSafety("europe", ["Dangerous", "40.727021", "-74.034262"]);
createZoneSafety("europe", ["Safe", "40.726889", "-74.035021"]);
createZoneSafety("europe", ["Cautious", "40.729840", "-74.035311"]);
createZoneSafety("europe", ["Dangerous", "40.727919", "-74.037488"]);
createZoneSafety("europe", ["Cautious", "40.727523", "-74.036212"]);

var userId = 123456789;
createUser(userId, "John", "Smith", "test@example.com", [1,2,3],"test", ["1,-1","2,-2","3,-3"], "US", "NY", "New York");
var currLoc = getUserCurrLocation(userId);
var homeLoc = getUserHomeLocation(userId);
var previousLoc = getUserPreviousLocation(userId);
console.log(currLoc);
console.log(homeLoc);
console.log(previousLoc);
//sendMessage('no', '19086037936', '19042043485');
