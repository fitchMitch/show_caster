$(document).ready ->
  write_it = (w, h)->
    s = "hauteur : #{h}  x largeur : #{w}"
    $('#widthbox').text s
    return

  observer = new MutationObserver((mutations) ->
    mutations.forEach (mutationRecord) ->
      h = parseInt($('#photo_crop_h').val(), 10)
      w = parseInt($('#photo_crop_w').val(), 10)
      write_it(w, h)
      indicatorsDisplay(w, h)
      return
    return
  )
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

  target = document.getElementById("photo_crop_w")
  observer.observe target,
    attributes: true
    attributeFilter: [ 'value' ]
