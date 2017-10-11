$(document).ready(function() {
  $("input[class~='validate-json-instance']").on("click", function() {
    var json_schema = $(this).attr("json_schema");
    var json_instance = $(this).parents(".panel-heading").
    siblings(".panel-body").find("textarea[class~='generated-json-instance-or-to-validate']").val();
    var display_result_element = $(this).parents(".panel-heading").
    siblings(".panel-body").find("div[id*='json-validation-result']");
    validate_json_instance(json_schema, json_instance, display_result_element);
  });

  $("#generate_json_instance").on("click", function() {
    var json_schema = $("input:radio[name=generation_json_schema]:checked").val();
    if (json_schema) {
      generate_json_instance(json_schema, display_generated_instance);
    } else {
      setClass('#json_generation_result', "alert alert-warning");
      $('#json_generation_result').text("Please select which schema you wish to generate an instance of.");
    }
  });
});