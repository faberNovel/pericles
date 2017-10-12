function get_resource_representation_url(resource_id, resource_representation_id) {
  return '/resources/' + resource_id + '/resource_representations/' + resource_representation_id + '.json_schema';
}

function generate_schema_from_resource_representation(clicked_button) {
  var select_element = $(clicked_button).siblings(".form-group").find("select");
  var resource_representation_id = select_element.val();
  if (resource_representation_id) {
    var resource_id = $(clicked_button).attr('resource_id');
    var url = get_resource_representation_url(resource_id, resource_representation_id);
    var params = '?is_collection=' + $(clicked_button).siblings('.checkbox').find('input[type=checkbox]')[0].checked;
    params += '&root_key=' + $(clicked_button).siblings('.form-group').children('input.root-key').val();
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