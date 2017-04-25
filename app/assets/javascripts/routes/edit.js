$(document).ready(function() {
  var url = window.location.pathname.replace('/edit', '.json_schema');
  $("#generate_json_schema_from_resource").on("click", function() {
    $.ajax({
        type: "GET",
        url: url,
        dataType: 'json'
      })
      .done(function(data) {
        var result_json = {};
        var original_data = $('#json_schema_from_resource_text_area').text();
        if (original_data) {
          original_json = JSON.parse(original_data);
          result_json = deep_merge(original_json, data);
        } else {
          result_json = data;
        }
        $('#json_schema_from_resource_text_area').text(JSON.stringify(result_json, null, 2));
      });
  });
});


function deep_merge(first_object, last_object) {
  var result = first_object;
  for (var key in first_object) {
    if (last_object[key] && isObject(last_object[key])) {
      result[key] = deep_merge(first_object[key], last_object[key]);
    } else {
      result[key] = first_object[key];
    }
  }
  for (var key_last_object in last_object) {
    if (!result[key_last_object]) {
      result[key_last_object] = last_object[key_last_object];
    }
  }
  return result;
}

function isObject(item) {
  return (item && typeof item === 'object' && !Array.isArray(item));
}
