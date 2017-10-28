var admin = require("firebase-admin");

// Initialize the app with a service account, granting admin privileges
admin.initializeApp({
  credential: admin.credential.cert("rescue-sec-e9e0b9033721.json"),
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

createUser(123456789, "John", "Smith", "test@example.com", [1,2,3],"test", ["1,-1","2,-2","3,-3"]);
