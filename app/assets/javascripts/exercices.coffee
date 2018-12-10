if $("#exercice_skill_list").length > 0
  $element = $("#exercice_skill_list").select2
    tags: true,
    tokenSeparators: [','],
    width: 400,
    label: true
