$(document).ready(function() {
  $("#validate_json_instance").on("click", function() {
    var json_schema = $("#json_schema").val();
    var json_instance = $("#json_instance").val();
    var display_result_element = $("#json-validation-result");
    validate_json_instance(json_schema, json_instance, display_result_element);
  });
});