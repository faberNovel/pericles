function display_generated_instance(instance) {
  var instance_string = JSON.stringify(instance, null, 2);
  var generation_result_element = $('#json_generation_result');
  generation_result_element.removeClass();
  generation_result_element.empty();
  generation_result_element.append('<pre class="pre-scrollable"> <code>' + instance_string + '</code> </pre>');
}

function generate_json_instance(json_schema, callback) {
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
    .done(callback)
    .fail(function(data) {
      console.log(data);
    });
}
