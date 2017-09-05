$(document).ready(function() {
  $("#route_responses").children(".fields").each(set_id_response_element);

  $(this).on('nested:fieldAdded:responses', function(event) {
    var field_element = event.field.get(0);
    set_id_response_element(0, field_element);
  });

  $('input').filter(function() {
    return this.id.match(/headers_attributes_\d+_name$/) !== null;
  }).each(set_autocomplete);

  $(this).on('nested:fieldAdded:request_headers nested:fieldAdded:headers', function(event) {
    var input_element = event.field.find(".form-group:first input").get(0);
    set_autocomplete(0, input_element);
  });

});

function get_response_number(response_element) {
  var response_number = $(response_element).find(".form-group:first label").attr("for").match(/\d+/)[0];
  return response_number;
}

function set_id_response_element(index, element) {
  var response_number = get_response_number(element);
  set_id_response_headers_table(element, response_number);
}

function set_id_response_headers_table(element, response_number) {
  var response_table_headers_id = "table_response_" + response_number + "_headers";
  $(element).find("table").attr("id", response_table_headers_id);
  $(element).find("a.add_nested_fields").attr("data-target", "#" + response_table_headers_id);
}

function generate_schema_from_resource_representation(clicked_button) {
  var select_element = $(clicked_button).siblings(".form-group").find("select");
  var resource_representation_id = select_element.val();
  if (resource_representation_id) {
    var url = window.location.pathname.replace(/routes\/\d+\/edit|routes\/new/, 'resource_representations/' + resource_representation_id + '.json_schema');
    var params = '?is_collection=' + $(clicked_button).siblings('.checkbox').find('input[type=checkbox]')[0].checked;
    var body_json_schema = $(clicked_button).siblings(".form-group").children("textarea");
    $.ajax({
        type: "GET",
        url: url + params,
        dataType: 'json'
      })
      .done(function(data) {
        var result_json = {};
        var original_data = body_json_schema.val();
        if (original_data) {
          original_json = JSON.parse(original_data);
          result_json = deep_merge(original_json, data);
        } else {
          result_json = data;
        }
        body_json_schema.val(JSON.stringify(result_json, null, 2));
      });
  }
}

function set_autocomplete(index, element) {
  $(element).autocomplete({
    source: function(request, response) {
      jQuery.get("/headers", {
        term: request.term
      }, function(data) {
        var field_name_array = data.headers.map(function(header) {
          return header.name;
        });
        response(field_name_array);
      },
      "json");
    },
    messages: {
      noResults: '',
      results: function() {}
    }
  });
}

function deep_merge(first_object, last_object) {
  var result = first_object;
  for (var key in first_object) {
    if (last_object[key] && isObject(last_object[key])) {
      result[key] = deep_merge(first_object[key], last_object[key]);
    } else {
      result[key] = first_object[key];
    }
  }
  for (var key_last_object in last_object) {
    if (!result[key_last_object]) {
      result[key_last_object] = last_object[key_last_object];
    }
  }
  return result;
}

function isObject(item) {
  return (item && typeof item === 'object' && !Array.isArray(item));
}
