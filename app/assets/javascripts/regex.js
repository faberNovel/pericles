$(document).ready(function () {
  RegexColorizer.addStyleSheet();
  RegexColorizer.colorizeAll();

  $('.regex').on('focus', function() {
    this.innerHTML = this.textContent || this.innerText;
  });

  $('.regex').on('blur', function() {
    RegexColorizer.colorizeAll();

    target = $(this).data('target');
    $(this).parent().find("input[id$='" + target + "']").val(this.textContent || this.innerText);
  });
});
