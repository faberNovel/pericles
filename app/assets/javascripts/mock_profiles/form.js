$(document).ready(function() {
  $('input:radio').click(function() {
    $(this).parents('.responses').find('input:radio').prop('value', false);
    $(this).parents('.responses').find('input:radio').prop('checked', false);
    $(this).prop('checked', true);
    $(this).prop('value', true);
    $(this).parents('.response').find("input:hidden[name~='is_favorite']").val('true')
  });
});