$(document).ready ->
  write_it = (w, h)->
    s = "hauteur : #{h}  x largeur : #{w}"
    $('#widthbox').text s
    return
  indicatorsDisplay = (w, h) ->
    if w > 0
      if Math.abs(h/w - 1) < 0.01
        $("#widthbox").addClass("squareBorder")
        $("#square").show()
      else
        $("#widthbox").removeClass("squareBorder")
        $("#square").hide()

      if Math.abs(h/w - 9/16) < 0.01
        $("#widthbox").addClass("movieBorder")
        $("#movie").show()
      else
        $("#widthbox").removeClass("movieBorder")
        $("#movie").hide()
    return
  allow_submission = (e) ->
    if picture_handler == undefined || picture_handler.files.length == 0
      $("#photo_validation_button").prop('disabled', 'disabled')
      $("#loader").hide()
    else if picture_handler.files.length > 0
      $("#photo_validation_button").prop('disabled', false).hide('slow')
      $("#loader").show("slow")
      $("#new_picture").submit()
    e.stopPropagation() if e != undefined
  #==========================
  #=======   MAIN   =========
  #==========================
  allow_submission()
  $("#loader").hide()
  picture_handler = document.getElementById("picture_photo")
  if picture_handler != null
    allow_submission() if picture_handler.length > 0
    $("#picture_photo").on 'change', allow_submission

  observer = new MutationObserver((mutations) ->
    mutations.forEach (mutationRecord) ->
      h = parseInt($('#photo_crop_h').val(), 10)
      w = parseInt($('#photo_crop_w').val(), 10)
      write_it(w, h)
      indicatorsDisplay(w, h)
      return
    return
  )

  target = document.getElementById("photo_crop_w")
  observer.observe target,
    attributes: true
    attributeFilter: [ 'value' ]
