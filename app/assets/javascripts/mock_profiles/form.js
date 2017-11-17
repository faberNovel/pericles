$(document).on('nested:fieldAdded', function(event){
  var field = event.field;
  var responseField = field.find('.response-id');

  var value = responseField.parents('.response').attr('data-response-id')
  responseField.val(value);
  $('select').chosen();
})