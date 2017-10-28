// Set the configuration for your app
  // TODO: Replace with your project's config object
  var config = {
    apiKey: "AIzaSyAEqlV5WMCzLIPKayUMNIqatleugWx4Sw0",
    authDomain: "rescue-sec.firebaseapp.com",
    databaseURL: "https://rescue-sec.firebaseio.com"
  };
  firebase.initializeApp(config);

  // Get a reference to the database service
  var database = firebase.database();