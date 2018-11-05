$(document).ready ->

  course_title_change = (e) ->
    cond = $("input:checked").val() == '0'
    first_word = if cond then "Cours" else "Auto-coachée"
    #course_event_date_3i day
    #course_event_date_2i month
    title = "#{first_word} du #{$("#course_event_date_3i").val()} "
    title +="#{$("#course_event_date_2i option:selected").text()}"
    $("#course_title").val(title)

  switch_autocoached_course = (e) ->
    show_players = $("input:checked").val() == '0'
    if show_players
      $(".is_autocoached").hide()
      $(".is_not_autocoached").show()
    else
      $(".is_autocoached").show()
      $(".is_not_autocoached").hide()
    course_title_change()
    return

  # ---------------------------
  # Main
  # ---------------------------
  switch_autocoached_course()
  $(
    "#course_is_autocoached_1,
     #course_is_autocoached_0"
  ).on 'click', switch_autocoached_course
  $("#course_event_date_3i").on 'change', course_title_change
  $("#course_event_date_2i").on 'change', course_title_change
