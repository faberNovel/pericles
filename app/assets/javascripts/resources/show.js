function onRepresentationClick() {
  if (window.STATE === 'MANAGE') {
    $('.btn.representation-btn').removeClass('selected');
  }
  $(this).toggleClass('selected');

  updateRows();
}

function onAllClick() {
  $('.btn.representation-btn').removeClass('selected');

  updateRows();
}

function updateRows() {
  let rows = $('#table > .table-row.flexwrap');
  var shouldShowRows = rows.map(function() {
    return true;
  });

  let selectedButtons = $('.btn.representation-btn.selected')
  selectedButtons.each(function(indice, btn) {
    let index = $(btn).index() - 1;
    let shouldShowRowsOfRepresentation = rows.map(function() {
      let circle = $(this).find('.cell.circles').children()[index];
      let shouldShow = $(circle).hasClass('selected');
      return shouldShow;
    });

    shouldShowRows = shouldShowRowsOfRepresentation.map(function(indice, boolean) {
      return shouldShowRows[indice] && boolean;
    });
  });

  updateRowsVisibility(rows, shouldShowRows);
}

function updateRowsVisibility(rows, shouldShowRows) {
  $('.delete-me').remove();
  shouldShowRows.each(function (index, boolean) {
    let row = $(rows[index]);
    if (boolean) {
      row.animate({height: "show", opacity: "show"}, 300);
    }
    else {
      row.animate({height: "hide", opacity: "hide"}, 300);
      // Make :nth-child css keep working
      row.after('<div class="delete-me"></div>');
    }
  });
}

function onExpandAllClick() {
  $('.contraints-row').collapse('show');
}

function onEnterManage() {
  $('#manage').hide('fast');
  $('#filter-text').text('Manage representations');
  $('#buttons-row').animate({height: "show", opacity: "show"}, 300);
  $('.circle').addClass('hoverable');
  $('#all').animate({width: "hide", opacity: "hide", 'padding-left': 'hide', 'padding-right': 'hide'}, 300);
  onAllClick();
  window.STATE = 'MANAGE';
}

function onCancelManage() {
  $('#manage').show('fast');
  $('#filter-text').text('Filter by representation :');
  $('#buttons-row').animate({height: "hide", opacity: "hide"}, 300);
  $('.circle').removeClass('hoverable');
  $('#all').animate({width: "show", opacity: "show", 'padding-left': 'show', 'padding-right': 'show'}, 300);
  onAllClick();
  window.STATE = 'SHOW';
}

function onCircleClick() {
  if (window.STATE === 'MANAGE') {
    $(this).toggleClass('selected');
    let representationIndice = $(this).index();
    let attributeIndice = $(this).parent().parent().parent().index() - 1;
    window.representations[representationIndice]
      .attributes_resource_representations_attributes[attributeIndice]
      ._destroy = !$(this).hasClass('selected');
  }
}

function updateResourceRepresentations() {
  let resourceId = $('#resource-show > h1').attr('id');
  let promises = window.representations.map(function(representation, representationIndice) {
    let id = representation.id;

    return $.ajax({
      type: "PUT",
      url: "/resources/" + resourceId + "/resource_representations/" + id,
      data: JSON.stringify({resource_representation: representation}),
      contentType: "application/json",
      dataType: "json"
    })
    .then(function(data) {
      attributesData = data.resource_representation.attributes_resource_representations;
      attributesState = window.representations[representationIndice].attributes_resource_representations_attributes;
      attributesStateValues = Object.values(attributesState);
      attributesStateValues.forEach(function (attributeState, stateIndice) {
        dataIndice = attributesData.findIndex(function (attributeData) {
          return attributeData.attribute_id == attributeState.attribute_id;
        });
        if (dataIndice >= 0) {
          attributesState[stateIndice] = attributesData[dataIndice];
        } else {
          attributesState[stateIndice].id = null;
        }
      });
    })
  });

  Promise.all(promises).then(function() {
    onCancelManage();
  });
}

function initRepresentationsState() {
  window.representations = $('.btn.representation-btn').slice(1).map(
    function (indice, representationBtn) {
      return {
        id: representationBtn.id,
        name: $(representationBtn).text(),
        attributes_resource_representations_attributes: getAttrResRepProperties(indice)
      };
    }
  ).toArray();
}

function getAttrResRepProperties(indice) {
  let attributes = $('#table > .table-row.flexwrap').map(function (rowIndice, row) {
    // The circle element contains all the data about the
    // AttributesResourceRepresentation
    let circle = $($(row).find('.cell.circles').children()[indice]);

    return {
      id: circle.attr('attributes-resource-representation-id'),
      attribute_id: circle.attr('attribute-id'),
      _destroy: !circle.attr('attributes-resource-representation-id')
    }
  }).toArray();

  return convertArrayToRubyNestedHash(attributes);
}

function convertArrayToRubyNestedHash(array) {
  return array.reduce(function(hash, obj, indice) {
    hash[indice] = obj;
    return hash;
  }, {});
}

$(document).ready(function () {
  window.STATE = 'SHOW';
  $('.btn.representation-btn').on('click', onRepresentationClick);
  $('.btn.representation-btn#all').on('click', onAllClick);
  $('#expandAll').on('click', onExpandAllClick);
  $('#manage').on('click', onEnterManage);
  $('#cancel').on('click', onCancelManage);
  $('.circle').on('click', onCircleClick);
  $('#update').on('click', updateResourceRepresentations);
  initRepresentationsState();
});