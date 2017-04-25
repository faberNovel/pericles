$(document).ready(function() {
  var url = window.location.pathname.replace('/edit', '.json_schema');
  $("#generate_json_schema_from_resource").on("click", function() {
    $.ajax({
        type: "GET",
        url: url,
        dataType: 'json'
      })
      .done(function(data) {
        $('#json_schema_from_resource_text_area').text(JSON.stringify(data, null, 2));
      });
  });
});
