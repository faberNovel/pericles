function generateJsonInstance(jsonSchema, callback) {
  var schema = JSON.parse(jsonSchema);
  var data = {
    schema: schema
  };
  $.ajax({
      type: "POST",
      url: "/instances",
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json"
    })
    .done(function(data) {
      callback(data);
    })
    .fail(function(data) {
      console.log(data);
    });
}
