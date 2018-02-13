$(document).ready(function () {
  $("select").chosen({allow_single_deselect: true, search_contains: true});
  $(document).on('cocoon:after-insert', function () {
    $("select").chosen({allow_single_deselect: true, search_contains: true});
  });

  $('[data-toggle="tooltip"]').tooltip();
  hljs.initHighlightingOnLoad();
});

