$(document).ready(function() {
  $("input[class~='validate-json-instance']").off('click').on("click", function() {
    var json_schema = $(this).attr("json_schema");
    var json_instance = $(this).parents(".panel-heading").
    siblings(".panel-body").find("textarea[class~='generated-json-instance-or-to-validate']").val();
    var display_result_element = $(this).parents(".panel-heading").
    siblings(".panel-body").find("div[id*='json-validation-result']");
    validate_json_instance(json_schema, json_instance, display_result_element);
  });

  $("input[class~='generate-json-instance']").off('click').on("click", function() {
    var json_schema = $(this).attr("json_schema");
    var display_result_element = $(this).parents(".panel-heading").
    siblings(".panel-body").find("textarea[class~='generated-json-instance-or-to-validate']");
    generate_json_instance(json_schema, display_result_element);
  });
});