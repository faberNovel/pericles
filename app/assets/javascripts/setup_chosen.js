$(document).ready(function () {
  $("select").chosen();
  $(document).on('cocoon:after-insert', function () {
    $("select").chosen();
  });
});