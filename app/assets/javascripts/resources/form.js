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

function onIsArrayChanged(input) {
  var fields = $(input).parents('.fields');
  var minItems = fields.find(".constraints input[id$='min_items']").parents('.form-group');
  var maxItems = fields.find(".constraints input[id$='max_items']").parents('.form-group');

  if ($(input).is(':checked')) {
    minItems.show();
    maxItems.show();
    fields.find(".main option").each(function() {
      $(this).text('Array of ' + $(this).text());
    });
    fields.find('select').trigger("chosen:updated");
  } else {
    minItems.hide();
    maxItems.hide();
    fields.find(".main option").each(function() {
      $(this).text($(this).text().replace('Array of ', ''));
    });
    fields.find('select').trigger("chosen:updated");
  }
}


$(document).ready(function () {
  $('.fields .main select option:selected').each(function() {
    onSelectChanged(this);
  });

  $(".fields .main input[id$='is_array']").each(function() {
    onIsArrayChanged(this);
  });

  $(".fields .main input[id$='is_array']").on('click', function() {
    onIsArrayChanged(this);
  });

  $('.fields .main select').change(function () {
    onSelectChanged($(this).children('option:selected')[0]);
  });

});