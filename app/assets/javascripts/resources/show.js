$(document).ready(function () {
  function onRepresentationClick() {
    $(this).toggleClass('selected');
  }

  function onAllClick() {
    $('.btn.representation-btn').removeClass('selected');
  }

  $('.btn.representation-btn').on('click', onRepresentationClick);
  $('.btn.representation-btn#all').on('click', onAllClick);
});