function setClass(object, new_class) {
  object.removeClass();
  object.addClass(new_class);
}

function handle_parse_error(status, display_result_element) {
  var error_source;
  if (status == "schema_parse_error") {
    error_source = "schema";
  } else {
    error_source = "instance";
  }
  display_result_element.text("The input JSON " + error_source + " is not a valid JSON text (RFC 7159).");
}

function handle_validation_error(status, errors, display_result_element) {
  var error_text;
  if (status == "schema_validation_error") {
    error_text = "The input JSON schema does not conform to JSON Schema Draft 4. Errors:";
  } else {
    error_text = "The input JSON schema does not validate the input JSON instance (JSON Schema Draft 4). Errors:";
  }
  display_result_element.text(error_text);
  display_result_element.append("<ul></ul>");
  for (i = 0; i < errors.length; i++) {
    display_result_element.children("ul").append("<li>" + errors[i].description + "</li>");
  }
}

function handle_error(status, errors, display_result_element) {
  setClass(display_result_element, "alert alert-danger");
  if (status.includes("parse_error")) {
    handle_parse_error(status, display_result_element);
  } else {
    handle_validation_error(status, errors, display_result_element);
  }
}

function handle_success(display_result_element) {
  setClass(display_result_element, "alert alert-success");
  display_result_element.text("The input JSON schema validates the input JSON instance (JSON Schema Draft 4).");
}

function display_validation_result(result, display_result_element) {
  var status = result.validation.status;
  var errors = result.validation.json_errors;
  if (status == "success") {
    handle_success(display_result_element);
  } else {
    handle_error(status, errors, display_result_element);
  }
}

function validate_json_instance(json_schema, json_instance, display_result_element) {
  var data = {
    validation: {
      json_schema: json_schema,
      json_instance: json_instance
    }
  };
  $.ajax({
      type: "POST",
      url: "/validations",
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json"
    })
    .done(function(data) {
      display_validation_result(data, display_result_element);
    })
    .fail(function(data) {
      console.log(data);
    });
}