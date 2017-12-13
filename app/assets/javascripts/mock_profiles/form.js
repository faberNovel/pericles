$(document).ready(function() {
  $('#mock_profile_form').on('cocoon:after-insert', function(event, added_element) {
    var randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    var uniqid = randLetter + Date.now();

    var div = added_element[1];
    div['id'] = uniqid;
    var a = $(added_element[0]).children('a[href="#-advanced"]')[0];
    a['href'] = "#" + uniqid;


    // Regexp field need javascript listeners so if we add some we need to add back the listeners
    // TODO: Clément Villain 13/12/17 move this code in a function in regex_field gem
    $('#' + uniqid + ' .regex').on('focus', function() {
      this.innerHTML = this.textContent || this.innerText;
    });

    $('#' + uniqid + ' .regex').on('blur', function() {
      RegexColorizer.colorizeAll();

      target = $(this).data('target');
      $(this).parent().find("input[id$='" + target + "']").val(this.textContent || this.innerText);
    });
  })

  $('#mock_profile_form').on('cocoon:before-remove', function(event, removed_element) {
    var collapseId = removed_element.children('a[data-toggle="collapse"]')[0].href.split('#')[1];
    $('#' + collapseId).remove();
  })
});