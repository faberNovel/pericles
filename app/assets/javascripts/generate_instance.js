function display_generated_instance(instance, display_result_element) {
  var instance_string = JSON.stringify(instance, null, 2);
  display_result_element.empty();
  display_result_element.val(instance_string);
}

function generate_json_instance(json_schema, display_result_element) {
  var schema = JSON.parse(json_schema);
  var data = {
    schema: schema
  };
  $.ajax({
      type: "POST",
      url: "/instances",
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json"
    })
    .done(function(data) {
      display_generated_instance(data, display_result_element);
    })
    .fail(function(data) {
      console.log(data);
    });
}