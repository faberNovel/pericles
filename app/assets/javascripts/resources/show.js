function onRepresentationClick() {
  $(this).toggleClass('selected');
}

function onAllClick() {
  $('.btn.representation-btn').removeClass('selected');
}

function onExpandAllClick() {
  $('.contraints-row').collapse('show');
}

$(document).ready(function () {
  $('.btn.representation-btn').on('click', onRepresentationClick);
  $('.btn.representation-btn#all').on('click', onAllClick);
  $('#expandAll').on('click', onExpandAllClick);
});