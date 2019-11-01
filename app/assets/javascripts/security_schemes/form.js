function updateOnTypeChange () {
  const selectedType = $('#security_scheme_security_scheme_type').val()
  $(`.security-scheme-detail`).hide()
  $(`#security-scheme-detail-${selectedType}`).show()
}

$(document).ready(function () {
  $('#security_scheme_security_scheme_type').on('change', updateOnTypeChange);
  updateOnTypeChange();
});