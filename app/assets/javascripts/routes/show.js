$(document).ready(function() {
  let editors = {};

  $("input[class~='validate-json-instance']").off('click').on("click", function() {
    let json_schema = $(this).attr("json_schema");
    var editorContainer = $(this)
      .parents(".panel-heading")
      .siblings(".panel-body")
      .find(".jsoneditor-container")[0];
    var json_instance = JSON.stringify(editors[editorContainer.id].get());
    var display_result_element = $(this)
      .parents(".panel-heading")
      .siblings(".panel-body")
      .find("div[id*='json-validation-result']");

    validate_json_instance(json_schema, json_instance, display_result_element);
  });

  $("input[class~='generate-json-instance']").off('click').on("click", function() {
    var jsonSchema = $(this).attr("json_schema");
    var editorContainer = $(this)
      .parents(".panel-heading")
      .siblings(".panel-body")
      .find(".jsoneditor-container")[0];
    console.log(editorContainer);

    generateJsonInstance(jsonSchema, function(data) {
      editors[editorContainer.id].set(data)
    });
  });

  $('.jsoneditor-container').each(function() {
    container = this;
    options = {mode: container.hasAttribute('read-only') ? 'view' : 'code'};
    var editor = new JSONEditor(container, options);
    editor.set(JSON.parse(container.getAttribute('json')));
    editor.expandAll && editor.expandAll();
    editors[container.id] = editor;
  });
});
