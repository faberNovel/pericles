function onSelectChanged(option) {
  var minimum = $(option).parents('.fields').find(".constraints input[id$='minimum']").parents('.form-group');
  var maximum = $(option).parents('.fields').find(".constraints input[id$='maximum']").parents('.form-group');
  if (option.value === 'integer' || option.value == 'string') {
    minimum.show();
    maximum.show();
  } else {
    minimum.hide();
    maximum.hide();
  }
}


$(document).ready(function () {
  $('.fields .main select option:selected').each(function() {
    onSelectChanged(this);
  })

  $('.fields .main select').change(function () {
    onSelectChanged($(this).children('option:selected')[0]);
  });

});