$(document).ready(function() {
  $("#validate_json_instance").on("click", function() {
    var json_schema = $("input:radio[name=validation_json_schema]:checked").val();
    var json_instance = $("#json_instance").val();
    if (json_schema) {
      validate_json_instance(json_schema, json_instance, display_validation_result);
    } else {
      setClass('#json_validation_result', "alert alert-warning");
      $('#json_validation_result').text("Please select against which schema (body or response) you wish to validate the input JSON instance.");
    }
  });

  $("#generate_json_instance").on("click", function() {
    var json_schema = $("input:radio[name=generation_json_schema]:checked").val();
    if (json_schema) {
      generate_json_instance(json_schema, display_generated_instance);
    } else {
      setClass('#json_generation_result', "alert alert-warning");
      $('#json_generation_result').text("Please select which schema (body or response) you wish to generate an instance of.");
    }
  });
});
