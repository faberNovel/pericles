$(document).ready(function() {
  $("#validate_json_instance").on("click", function() {
    var json_schema = $("input:radio[name=json_schema]:checked").val();
    var json_instance = $("#json_instance").val();
    if (json_schema) {
      validate_json_instance(json_schema, json_instance, display_validation_result);
    } else {
      setClass('#json_validation_result', "alert alert-warning");
      $('#json_validation_result').text("Please select against which schema (body or response) you wish to validate the input JSON instance.");
    }
  });
});
