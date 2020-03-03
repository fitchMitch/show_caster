# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    case level.to_sym
      # allow either standard rails flash category symbols...
    when :notice then 'info'
    when :success then 'success'
    when :alert then 'warning'
    when :error then 'danger'
    # ... or bootstrap class symbols
    when :info then 'info'
    when :warning then 'warning'
    when :danger then 'danger'
    # and default to being alarming
    else 'danger'
    end
  end

  # Returns the full title on a per-page basis.
  def page_title(page_title = '')
    base_title = I18n.t('theater_company')
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def red_bell_notice(current_user, size = 1)
    icon = "bell #{size}x"
    ficon = fa_icon(icon)
    bell = "<span class='bell'>#{ficon}</span>"
    Poll.expecting_my_vote(current_user).positive? ? bell.html_safe : ''
  end

  def title_with_image(image_name, i18n_text)
    picto = "icons/png/#{image_name}"
    image_tag(picto, size: 60) + image_tag('transp.png') + I18n.t(i18n_text)
  end

  def back_sign
    fa_icon('arrow-circle-left', text: t('back'))
  end

  def cosy_puts(arg = nil)
    puts '= ' * 20
    arg.nil? ? yield : (puts arg)
    puts '= ' * 20
  end
end
