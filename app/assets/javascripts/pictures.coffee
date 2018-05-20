$(document).ready ->
  write_it = ->
    h = parseInt($('#photo_crop_h').val(), 10)
    w = parseInt($('#photo_crop_w').val(), 10)
    s = "hauteur : #{h}  x largeur : #{w}"
    $('#widthbox').text s
    if w > 0
      if (h/w - 1) < 0.01 and (h/w - 1) > -0.01
        $("#widthbox").addClass("squareBorder")
      else
        $("#widthbox").removeClass("squareBorder")
    return

  observer = new MutationObserver((mutations) ->
    mutations.forEach (mutationRecord) ->
      write_it()
      return
    return
  )
  target = document.getElementById("photo_crop_w")
  observer.observe target,
    attributes: true
    attributeFilter: [ 'value' ]
