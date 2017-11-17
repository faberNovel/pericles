function hideSelect() {
  $(".error-response .resource-instances").parents(".form-group").hide();
  $(".resource-response .api-error-instances").parents(".form-group").hide();
  $('.chosen-container').css('width', 'auto');
  $('select').chosen();
}

$(document).on('nested:fieldAdded', function(event){
  var field = event.field;
  var responseField = field.find('.response-id');

  var value = responseField.parents('.response').attr('data-response-id')
  responseField.val(value);
  hideSelect();
});

$(document).ready(hideSelect);