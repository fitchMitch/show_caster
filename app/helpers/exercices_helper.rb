module ExercicesHelper
  # include IconsHelper
  # include SeasonsHelper
  # include LoggingHelper

  def skill_tag_display(experience)
    return if experience.skill_list.empty?

    res = []
    experience.skill_list.each do |tag|
      res << content_tag(:span, tag, class: ['label', 'label-success'])
    end
    res.join(image_tag('transp.png')).html_safe
  end
end
