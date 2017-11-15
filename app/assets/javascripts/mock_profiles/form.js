$(document).on('nested:fieldAdded', function(event){
  var field = event.field;
  var responseField = field.find('.response-id');

  var value = responseField.parents('.fields').siblings().children('.response-id').val()
  responseField.val(value);
  $('select').chosen();
})