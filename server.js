var admin = require("firebase-admin");
//var firebase = require("./database/index.js");

admin.initializeApp({
  credential: admin.credential.cert("rescue-sec-sa.json"),
  databaseURL: "https://rescue-sec.firebaseio.com"
});
var db = admin.database();

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
