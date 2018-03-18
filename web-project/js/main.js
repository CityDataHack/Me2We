$('#weather-inputs button').click(function() {
  $('.selected').removeClass('selected');
  $(this).addClass('selected');
  $('#send-btn').prop("disabled", false);
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
    epoch: (new Date).getTime()
  };

  console.log(postData);

  // Get a key for a new Post.
  var newPostKey = firebase.database().ref().push().key;

  // Write the new post's data simultaneously in the posts list and the user's post list.
  var updates = {};
  updates[newPostKey] = postData;

  return firebase.database().ref().update(updates);
}

firebase.initializeApp(firebaseConfig);

navigator.geolocation.getCurrentPosition(showPos);

let myLat;
let myLng;

function showPos(pos) {
  myLat = pos.coords.latitude;
  myLng = pos.coords.longitude;
}

// let mysnap;
// firebase.database().ref(' ').once('value').then(function(snapshot) {
//   console.log(snapshot.val());
//   mysnap = snapshot.val();
// });

$('.menu-btn').click(function() {
  $('.cover').removeClass('hide-me');
});

$('.cover').click(function() {
  $(this).addClass('hide-me');
});