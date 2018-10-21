
$ ->
  days = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]
  types = ["course", "performance"]
  performance_selectors = ("#performance_event_date_#{sel}i" for sel in [1..3])
  course_selectors = ("#course_event_date_#{sel}i" for sel in [1..3])
  selectors_val = (selector_array) -> ($(sel).val() for sel in selector_array)
  change_day_name = (sels) ->
    d = new Date(selectors_val(sels).join(","))
    $("#day_name").remove() if $(".d-flex.flex-row > #day_name").length
    $(".d-flex.flex-row").prepend($("<div id='day_name'>#{days[d.getDay()]}</div>"))
    return
  trigger = (type) ->
    selectors = eval("#{type}_selectors")
    if $("##{type}_event_date_2i").length
      change_day_name(selectors)
      $(document).on('change', selectors.join(","), ()->
        change_day_name(selectors)
      )
  trigger type for type in types
  return
