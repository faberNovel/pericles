function updateOnStatusChange () {
  if (!$('#response_status_code').val()) {
    $('#response_api_error_id').parent().hide();
    $('#response_resource_representation_id').parent().hide();
    return;
  }

  if ($('#response_status_code').val() >= 400) {
    $('#response_resource_representation_id').val('').trigger('chosen:updated');
    $('#response_resource_representation_id').parent().hide();
    $('#response_api_error_id').parent().show()
  } else {
    $('#response_api_error_id').val('').trigger('chosen:updated');
    $('#response_api_error_id').parent().hide();
    $('#response_resource_representation_id').parent().show()
  }
}

$(document).ready(function () {
  $('#response_status_code').on('change', updateOnStatusChange);

  updateOnStatusChange();
});