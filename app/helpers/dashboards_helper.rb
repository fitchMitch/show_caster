module DashboardsHelper
  def local_lang_translate(key)
    t("dashboards.#{key}")
  end

  def show_perf(perf_and_average_array)
    player_performance, average = perf_and_average_array
    performances_count = player_performance.nil? ? "0" : player_performance.to_s
    if performances_count == "0"
      "<span class='label label-success'>#{fa_icon 'times'}</span>".html_safe
    elsif player_performance.to_i <= average.to_i
      "<span class='label label-success'>" \
      "#{performances_count} fois</span>".html_safe
    else
      "<span class='label label-danger'>" \
      "#{performances_count} fois</span>".html_safe
    end
  end
end
