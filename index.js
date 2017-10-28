var admin = require("firebase-admin");

// Initialize the app with a service account, granting admin privileges
admin.initializeApp({
  credential: admin.credential.cert("1rcrl-7bad2de229.json"),
  databaseURL: "https://rescue-sec.firebaseio.com"
});

// As an admin, the app has access to read and write all data, regardless of Security Rules
var db = admin.database();

var rootRef = db.ref();

// Create a new user
function createUser(userId, firstName, lastName, email, contacts, title, locations){
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
      }
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
	
	db.ref('users/' + userId + '/locations/current').once('value').then(
	function(snapshot) {
		loc = snapshot.val() || 'None';
	});
	
	return loc;
}

function getUserHomeLocation(userId) {
	var loc = 'None';
	
	db.ref('users/' + userId + '/locations/home').once('value').then(
	function(snapshot) {
		loc = snapshot.val() || 'None';
	});
	
	return loc;
}

function getUserPreviousLocation(userId) {
	var loc = 'None';
	
	db.ref('users/' + userId + '/locations/previous').once('value').then(
	function(snapshot) {
		loc = snapshot.val() || 'None';
	});
	
	return loc;
}

createUser(123456789, "John", "Smith", "test@example.com", [1,2,3],"test", ["1,-1","2,-2","3,-3"]);