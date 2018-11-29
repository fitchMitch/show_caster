max_char = 250
message = 'En attente ...'
$('#user_bio').on 'keyup', ->
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

if $("#about_me").length > 0
  random_time = (x, delta) -> x * Math.random() + delta
  $(".shine_1").show(random_time(750,0))
  $(".shine_4").show(random_time(1000,500))
  $(".shine_2").show(random_time(1500,1000))
  $(".shine_3").show(random_time(2000,1500))
  $(".shine_5").show(random_time(2500,2000))
return
