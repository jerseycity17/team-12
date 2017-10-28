// Dependencies
const admin = require("firebase-admin");
const express = require('express');
const bodyParser = require('body-parser');

// Setup
admin.initializeApp({
  credential: admin.credential.cert("rescue-sec-sa.json"),
  databaseURL: "https://rescue-sec.firebaseio.com"
});
const db = admin.database();
const app = express();

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// API

// Create a new office
app.post('/add/offices', (req, res) => {
  const {region, country, fieldOffice, location} = req.body;
  db.ref('offices/' + region + '/' + country + '/' + fieldOffice).set({
    region: region,
    country: country,
    fieldOffice: fieldOffice,
    location: location
  }, error => {
    if (error) {
      console.log(region);
      res.sendStatus(500);
    } else {
      res.sendStatus(201);
    }
  });
});

// Add a new contact for office
app.post('/add/offices/contacts', (req, res) => {
  const {region, country, fieldOffice, location, type, number} = req.body;
  db.ref('offices/' + region + '/' + country + '/' + fieldOffice + '/contacts/' + type).push(number);
  res.sendStatus(201);
});

// Get office info
app.get('/get/offices', (req, res) => {
  db.ref('offices').once('value').then( snapshot => {
    res.send(snapshot.val());
  });
});

// Create a new user
app.post('/add/users', (req, res) => {
  const {userId, firstName, lastName, email, contacts, title, locations, region, country, field} = req.body;
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
});


app.listen(3000, function () {
  console.log('Rescue Sec listening on port 3000!')
});
