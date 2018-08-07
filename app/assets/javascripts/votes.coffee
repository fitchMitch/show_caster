# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
remove_vote_classes = (selector) ->
  selector.removeClass("validated_vote invalidated_vote mitigated_vote")
  return
vote_validate = (elem) ->
  elem.form.submit()

$("[name*='vote_label']").each (index) ->
  $("option:selected", this).each (e) ->
    console.log("val " + $(this).val())
    elder = $(this).parent()
    remove_vote_classes(elder)
    elder.addClass("validated_vote") if $(this).val() == 'yess'
    elder.addClass("invalidated_vote") if $(this).val() == 'noway'
    elder.addClass("mitigated_vote") if $(this).val() == 'maybe'
  return

$("[name*='vote_label']").on 'change', (e) ->
  this.form.submit()
