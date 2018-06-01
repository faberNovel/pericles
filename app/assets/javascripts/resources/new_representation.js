$(document).ready(function() {
  $('.btn.selected').on('click', function () {
    var id = this.id;
    var resourceId = document.location.pathname.split('/')[2];
    var url = '/resources/' + resourceId + '/resource_representations/' + id + '/random';

    $.ajax({
      type: "GET",
      url: url,
      contentType: "application/json",
    }).then(function(data) {
      $('#resource_instance_body').val(JSON.stringify(data, null, 2));
    });
  })
});