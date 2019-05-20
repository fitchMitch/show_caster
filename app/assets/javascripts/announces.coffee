max_char = 250
message = 'En attente ...'

# create_option = (item) ->
#   option = new Option(item.name, item.id, true, false)
#   $element.append(option)

$('#announce_body').on 'keyup', ->
  common = "caractères - #{max_char} car max"
  car_count = @value.length
  if car_count > max_char
    $('#chars_left').removeClass('ok-chars')
    $('#chars_left').addClass('alert-chars-too-many')
    $("input[type='submit']").prop("disabled",true)
    message = "Retirer #{car_count - max_char} #{common} "
  else
    $('#chars_left').removeClass('alert-chars-too-many')
    $('#chars_left').addClass('ok-chars')
    $("input[type='submit']").prop("disabled",false)
    message = "plus que #{(max_char - car_count)} #{common}"
  $('#chars_left').text message
  return
