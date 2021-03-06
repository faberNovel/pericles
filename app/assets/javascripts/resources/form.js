function hasBoundaries(option) {
  return option.value === 'integer' || option.value === 'string' || option.value === 'number';
}

function shouldShowConstraintLink(option) {
  return option.value === 'string' || option.value === 'integer' || option.value === 'number';
}

function onSelectChanged(option) {
  var fields = $(option).parents('.fields');
  var minimum = fields.find(".constraints input[id$='minimum']").parents('.form-group');
  var maximum = fields.find(".constraints input[id$='maximum']").parents('.form-group');
  var min_max = fields.find(".constraints input[id$='maximum']").parents('.flex-row');

  var scheme_enum = fields.find(".constraints input[id$='enum']").parents('.flex-row');
  var scheme = fields.find(".constraints select[id$='scheme_id']").parents('.form-group');
  var enum_ = fields.find(".constraints input[id$='enum']").parents('.form-group');


  if (hasBoundaries(option)) {
    min_max.show();
  } else {
    minimum.find('input').val('');
    maximum.find('input').val('');
    min_max.hide();
  }

  let constraints = fields.find('.hide-show-link');
  if (shouldShowConstraintLink(option)) {
    constraints.css('opacity', 1);
    constraints.css('cursor', '');
  } else {
    constraints.css('opacity', 0);
    constraints.css('cursor', 'default');
  }

  if (option.value === 'string') {
    scheme_enum.find('.chosen-container').css('width', '150px');
    scheme.find('select').chosen({allow_single_deselect: true, search_contains: true, width: '150px'});
    scheme_enum.show();
  } else {
    scheme.find('select option').removeAttr('selected');
    enum_.find('input').val('');
    scheme_enum.hide();
  }

  fields.find(".constraints input[id$='minimum']").siblings('label').text(option.value === 'string' ? 'Length min.' : 'Minimum');
  fields.find(".constraints input[id$='maximum']").siblings('label').text(option.value === 'string' ? 'Length max.' : 'Maximum');
}

function onIsArrayChanged(input) {
  var fields = $(input).parents('.fields');
  var min_max = fields.find(".constraints input[id$='min_items']").parents('.flex-row');
  var minItems = fields.find(".constraints input[id$='min_items']").parents('.form-group');
  var maxItems = fields.find(".constraints input[id$='max_items']").parents('.form-group');

  if ($(input).is(':checked')) {
    min_max.show();
    fields.find(".main option").each(function() {
      $(this).text('Array of ' + $(this).text().replace('Array of ', ''));
    });
    fields.find('select').trigger("chosen:updated");
  } else {
    min_max.hide();
    minItems.find('input').val('');
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
      $(this).html('Hide constraints <span class="rotate">▾</span>');
    } else {
      $(this).text('Show constraints ▾');
    }
  });
}

function sortAttributesFromDom(dom) {
  return {
    id: dom.nextSibling.value,
    displayedType: $(dom).find('.chosen-container a.chosen-single span')[0].innerText,
    name: $(dom).find('[placeholder="name"]').val()
  }
}
$(document).ready(init);

function sortFromMode(sortMode) {
  $('.attributes > .nested-fields').sortDomElements((a, b) => {
    a = sortAttributesFromDom(a);
    b = sortAttributesFromDom(b);

    if (sortMode === 'alphabetical') {
      return a.name.toLowerCase().localeCompare(b.name.toLowerCase())
    } else if (sortMode === 'type') {
      let typeCompare = a.displayedType.toLowerCase().localeCompare(b.displayedType.toLowerCase());
      if (typeCompare === 0) {
        return a.name.toLowerCase().localeCompare(b.name.toLowerCase())
      } else {
        return typeCompare;
      }
    } else {
      return a.id - b.id;
    }
  });

  // Move add attribute section to the end of container
  $('.add-attribute.fields').sortDomElements();
}

$(document).ready(function () {
  let sortMode = localStorage.getItem('sortMode');
  sortFromMode(sortMode);

  $('form').on('cocoon:after-insert', function(event, addedElement) {
    init();

    var randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    var uniqid = randLetter + Date.now();

    var div = addedElement.find('.constraints')[0];
    div['id'] = uniqid;
    var a = addedElement.find('a[href="#attr-collapse-"]')[0];
    a['href'] = "#" + uniqid;
  });
});
