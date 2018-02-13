$(document).ready(function() {
  $('input').filter(function() {
    return this.id.match(/headers_attributes_\d+_name$/) !== null;
  }).each(set_autocomplete);

  $(this).on('cocoon:after-insert', function(event, addedItem) {
    var input_element = addedItem.find(".form-group:first input").get(0);
    set_autocomplete(0, input_element);
  });
});

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