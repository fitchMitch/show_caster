$(document).ready ->

  $("input#course_is_autocoached").attr('checked','checked')

  switch_it = (e) ->
    cond = $("input#course_is_autocoached:checked").length == 0
    $(".is_not_autocoached").toggleClass "show_me", cond
    $(".is_not_autocoached").toggleClass "hide_me", !cond
    $(".is_autocoached").toggleClass "show_me", !cond
    $(".is_autocoached").toggleClass "hide_me", cond
    course_title_change(e)
  # ---------------------------

  course_title_change = (e) ->
    cond = $("input#course_is_autocoached:checked").length == 0
    first_word = if cond then "Cours" else "Auto-coachée"
    #course_event_date_3i day
    #course_event_date_2i month
    title = "#{ first_word } du #{$("#course_event_date_3i").val()} #{$("#course_event_date_2i option:selected").text()} "
    $("#course_title").val(title)

  # ---------------------------
  # Main
  # ---------------------------
  $("input#course_is_autocoached").on 'click', switch_it
  $("#course_event_date_3i").on 'change', course_title_change
  $("#course_event_date_2i").on 'change', course_title_change
