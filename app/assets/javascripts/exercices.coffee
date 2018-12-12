if $("#exercice_skill_list").length > 0
  $element = $("#exercice_skill_list").select2
    tags: true,
    tokenSeparators: [','],
    width: 400,
    label: true
if $('.exercice-search').length > 0
  $('#q_skills_name_in, #q_energy_level_eq, #q_category_eq, #q_title_or_instructions_cont').on 'change', ->
    $('.exercice-search').submit()
