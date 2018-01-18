function onRepresentationClick() {
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

$(document).ready(function () {
  $('.btn.representation-btn').on('click', onRepresentationClick);
  $('.btn.representation-btn#all').on('click', onAllClick);
  $('#expandAll').on('click', onExpandAllClick);
});