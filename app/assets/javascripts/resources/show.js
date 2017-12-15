$(document).ready(function () {
  var url = document.location.toString();

  if (url.match('#')) {
    if(url.split('#')[1].startsWith('res-')) {
      $('.nav-tabs a[href="#resource-reps"]').tab('show');
    }

    $('.nav-tabs a[href="#' + url.split('#')[1] + '"]').tab('show');
    }

  // Change hash for page-reload
  $('.nav-tabs a').on('shown.bs.tab', function (e) {
    if(e.target.hash != 'resource-reps') {
      window.location.hash = e.target.hash;
      window.scrollTo(0, 0);
    }
  });
});