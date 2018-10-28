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

  def red_point(current_user)
    bell = "<span class='bell'>#{fa_icon('bell')}</span>"
    Poll.expecting_my_vote(current_user) > 0 ? bell.html_safe : ''
  end
end
