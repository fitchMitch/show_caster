module DashboardsHelper
  def translate(key)
    I18n.t("dashboards.#{key}")
  end

  def show_perf(reci)
    player_s_performance, average = reci
    text = player_s_performance.nil? ? 0 : player_s_performance.to_s
    if player_s_performance.to_i <= average.to_i
      "<span class='label label-success'>" \
      "#{text} fois</span>".html_safe
    else
      "<span class='label label-danger'>" \
      "#{text} fois</span>".html_safe
    end
  end
end
