function onSelectChanged(option) {
  var fields = $(option).parents('.fields');
  var minimum = fields.find(".constraints input[id$='minimum']").parents('.form-group');
  var maximum = fields.find(".constraints input[id$='maximum']").parents('.form-group');
  var scheme = fields.find(".constraints select[id$='scheme_id']").parents('.form-group');
  var enum_ = fields.find(".constraints input[id$='enum']").parents('.form-group');

  if (option.value === 'integer' || option.value == 'string' || option.value == 'number') {
    minimum.show();
    maximum.show();
  } else {
    minimum.hide();
    minimum.find('input').val('');
    maximum.hide();
    maximum.find('input').val('');
  }

  if (option.value === 'string') {
    scheme.show();
    scheme.find('.chosen-container').removeAttr('style');
    scheme.find('select').chosen({allow_single_deselect: true})
    enum_.show();
  } else {
    scheme.hide();
    scheme.find('select').val([]);
    enum_.hide();
    enum_.find('input').val('');
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
      $(this).text('Array of ' + $(this).text().replace('Array of ', ''));
    });
    fields.find('select').trigger("chosen:updated");
  } else {
    minItems.hide();
    minItems.find('input').val('');
    maxItems.hide();
    maxItems.find('input').val('');
    fields.find(".main option").each(function() {
      $(this).text($(this).text().replace('Array of ', ''));
    });
    fields.find('select').trigger("chosen:updated");
  }
}

function init() {
  $('.fields .main select option:selected').each(function() {
    onSelectChanged(this);
  });

  $(".fields .main input[id$='is_array']").each(function() {
    onIsArrayChanged(this);
  });

  $(".fields .main input[id$='is_array']").off('click').on('click', function() {
    onIsArrayChanged(this);
  });

  $('.fields .main select').off('change').change(function () {
    onSelectChanged($(this).children('option:selected')[0]);
  });

  $(".fields .main a[href^='#attr-collapse-']").off('click').on('click', function() {
    if($(this).parents('.fields').find('.constraints.collapse.in').length > 0) {
      $(this).text('Hide constraints');
    } else {
      $(this).text('Show constraints');
    }
  });
}

$(document).ready(init);
$(document).ready(function () {
  $('form').on('cocoon:after-insert', function(event, addedElement) {
    init();

    var randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    var uniqid = randLetter + Date.now();

    var div = addedElement.find('.constraints')[0];
    div['id'] = uniqid;
    var a = addedElement.find('a[href="#attr-collapse-"]')[0];
    a['href'] = "#" + uniqid;
  });
})
