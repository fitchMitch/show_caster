$('#answers').on('cocoon:before-insert', (e, answer_to_be_added) ->
  answer_to_be_added.fadeIn 'slow'
  return
).on('cocoon:before-remove', (e, answering) ->
  $(this).data 'remove-timeout', 800
  answering.fadeOut 'slow'
  return
)
