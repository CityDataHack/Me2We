$('#weather-inputs button').click(function() {
  $('.selected').removeClass('selected');
  $(this).addClass('selected');
});

$('#send-btn').click(function() {
  console.log('SEND: ' + $('.selected').val());
  writeNewWeather($('.selected').val());
});

function writeNewWeather(w) {
  // A post entry.
  var postData = {
    weather: w,
    lat: myLat,
    lng: myLng,
    date: Date(),
    epoch: (new Date).getTime(),
    comment: $('#comment').val()
  };

  // Get a key for a new Post.
  var newPostKey = firebase.database().ref().push().key;

  // Write the new post's data simultaneously in the posts list and the user's post list.
  var updates = {};
  updates[newPostKey] = postData;

  return firebase.database().ref().update(updates);
}



firebase.initializeApp(config);

navigator.geolocation.getCurrentPosition(showPos);

let myLat;
let myLng;

function showPos(pos) {
  var crd = pos.coords;

  console.log('Your current position is:');
  console.log(`Latitude : ${crd.latitude}`);
  console.log(`Longitude: ${crd.longitude}`);
  console.log(`More or less ${crd.accuracy} meters.`);

  myLat = crd.latitude;
  myLng = crd.longitude;
}


// let myLatLng = [];

// function getLocation() {
//     if (navigator.geolocation) {
//         navigator.geolocation.getCurrentPosition(showPosition);
//     }
// }

// function showPosition(position) {
//     // x.innerHTML = "Latitude: " + position.coords.latitude + 
//     // "<br>Longitude: " + position.coords.longitude;
//   // console.log(position.coords.latitude, position.coords.longitude);

//   myLatLng = [position.coords.latitude, position.coords.longitude];
// }

// // console.log(getLocation());