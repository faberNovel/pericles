if (!document.getElementById('jsf_script')) {
  var script = document.createElement('script');
  script.id = 'jsf_script';
  script.src = 'https://cdnjs.cloudflare.com/ajax/libs/json-schema-faker/0.4.1/json-schema-faker.min.js';
  document.head.appendChild(script);
}

function generate_json_instance(json_schema, callback) {
  var parsed_json_schema = JSON.parse(json_schema);
  var generated_instance = jsf(parsed_json_schema);
  callback(generated_instance);
}

function display_generated_instance(instance) {
  var instance_string = JSON.stringify(instance, null, 2);
  var generation_result_element = $('#json_generation_result');
  generation_result_element.removeClass();
  generation_result_element.empty();
  generation_result_element.append('<pre class="pre-scrollable"> <code>' + instance_string + '</code> </pre>');
}
