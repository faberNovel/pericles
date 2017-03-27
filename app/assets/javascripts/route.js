function setClass(select_string, new_class) {
  $(select_string).removeClass();
  $(select_string).addClass(new_class);
}

function handle_parse_error(status) {
  var error_source;
  if (status == "schema_parse_error") {
    error_source = "schema";
  } else {
    error_source = "instance";
  }
  $('#json_validation_result').text("The input JSON " + error_source + " is not a valid JSON text (RFC 7159).");
}

function handle_validation_error(status, errors) {
  var error_text;
  if (status == "schema_validation_error") {
    error_text = "The input JSON schema does not conform to JSON Schema Draft 4. Errors:";
  } else {
    error_text = "The input JSON schema does not validate the input JSON instance (JSON Schema Draft 4). Errors:";
  }
  var validation_result_element = $('#json_validation_result');
  validation_result_element.text(error_text);
  validation_result_element.append("<ul></ul>");
  for (i = 0; i < errors.length; i++) {
    $('#json_validation_result ul').append("<li>" + errors[i].description + "</li>");
  }
}

function handle_error(status, errors) {
  setClass('#json_validation_result', "alert alert-danger");
  if (status.includes("parse_error")) {
    handle_parse_error(status);
  } else {
    handle_validation_error(status, errors);
  }
}

function handle_success() {
  setClass('#json_validation_result', "alert alert-success");
  $('#json_validation_result').text("The input JSON schema validates the input JSON instance (JSON Schema Draft 4).");
}

function validate_json_instance(json_schema, json_instance) {
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
      var status = data.validation.status;
      var errors = data.validation.json_errors;
      if (status == "success") {
        handle_success();
      } else {
        handle_error(status, errors);
      }
    })
    .fail(function(data) {
      console.log(data);
    });
}

$(document).ready(function() {
  $("#validate_json_instance").on("click", function() {
    var json_schema = $("input:radio[name=json_schema]:checked").val();
    var json_instance = $("#json_instance").val();
    if (json_schema) {
      validate_json_instance(json_schema, json_instance);
    } else {
      setClass('#json_validation_result', "alert alert-warning");
      $('#json_validation_result').text("Please select against which schema (body or response) you wish to validate the input JSON instance.");
    }
  });
});
