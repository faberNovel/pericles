function onSelectChanged(option) {
  var fields = $(option).parents('.fields');
  var minimum = fields.find(".constraints input[id$='minimum']").parents('.form-group');
  var maximum = fields.find(".constraints input[id$='maximum']").parents('.form-group');
  var scheme = fields.find(".constraints select[id$='scheme_id']").parents('.form-group');
  var enum_ = fields.find(".constraints input[id$='enum']").parents('.form-group');

  if (option.value === 'integer' || option.value == 'string') {
    minimum.show();
    maximum.show();
  } else {
    minimum.hide();
    maximum.hide();
  }

  if (option.value === 'string') {
    scheme.show();
    enum_.show();
  } else {
    scheme.hide();
    enum_.hide();
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