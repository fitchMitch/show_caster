# $(document).ready ->
#   max = 250
#   txtarea = $("#user_bio")
#
#   txtarea = document.getElementById("user_bio")
#   display_count = $("#bio_length")
#
#   txtarea.keypress  = () ->
#     alert("m")
#     v_maxlength max
#   txtarea.onblur  = () ->
#     v_maxlength txtarea, display_count, max
#   txtarea.onkeyup  = () ->
#     v_maxlength txtarea, display_count, max
#   txtarea.onkeydown  = () ->
#     v_maxlength txtarea, display_count, max
#
#
#   v_maxlength = (max) ->
#     alert("me")
#     crop_txt txtarea, max
#     len = get_length txtarea
#     display_count.text(max - len)
#
#
#   get_length = (elem) ->
#     elem.value.length
#
#   crop_txt = (elem, max) ->
#     initial_length = get_length elem
#     if initial_length > 5 and initial_length > max
#       elem.value = elem.value.substr(0, max - 4) + " ..."
