function createUniqueId() {
  let randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
  return randLetter + Date.now();
}

function setupAdvancedLink(added_element, uniqId ) {
  let div = added_element[1];
  div['id'] = uniqId;
  let a = $(added_element[0]).children('a[href="#-advanced"]')[0];
  a['href'] = "#" + uniqId;
}

function setupRegexpField(uniqid) {
  let $regexp = $('#' + uniqid + ' .regex');
  $regexp.on('focus', function () {
    this.innerHTML = this.textContent || this.innerText;
  });

  $regexp.on('blur', function () {
    RegexColorizer.colorizeAll();

    target = $(this).data('target');
    $(this).parent().find("input[id$='" + target + "']").val(this.textContent || this.innerText);
  });
}

function afterInsert(event, addedElement) {
  let uniqid = createUniqueId();
  setupAdvancedLink(addedElement, uniqid);

  // Regexp field need javascript listeners so if we add some we need to add back the listeners
  // TODO: Clément Villain 13/12/17 move this code in a function in regex_field gem
  setupRegexpField(uniqid);
}

$(document).ready(function() {
  let $mockProfileForm = $('#mock_profile_form');
  $mockProfileForm.on('cocoon:after-insert', afterInsert);

  $mockProfileForm.on('cocoon:before-remove', function(event, removed_element) {
    let collapseId = removed_element.children('a[data-toggle="collapse"]')[0].href.split('#')[1];
    $('#' + collapseId).remove();
  })
});
