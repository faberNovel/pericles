$(document).ready(function() {
  $('#mock_profile_form').on('cocoon:after-insert', function(event, added_element) {
    var randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    var uniqid = randLetter + Date.now();

    var div = added_element[1];
    div['id'] = uniqid;
    var a = $(added_element[0]).children('a[href="#-advanced"]')[0];
    a['href'] = "#" + uniqid;
  })
});