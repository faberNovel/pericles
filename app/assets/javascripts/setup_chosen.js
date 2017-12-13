$(document).ready(function () {
  $("select").chosen({allow_single_deselect: true});
  $(document).on('cocoon:after-insert', function () {
    $("select").chosen({allow_single_deselect: true});
  });
});