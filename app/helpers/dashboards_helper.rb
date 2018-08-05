module DashboardsHelper
  def translate(key)
    expr = I18n.t("dashboards.#{key}")
  end

  def show_perf(reci)
    my = reci[0]
    av = reci [1]
    text = my.nil? ? "0" : "#{my}"
    if my.to_i <= av.to_i
      "<span class='label label-success'> \
      #{text} fois</span>".html_safe
    else
      "<span class='label label-danger'> \
      #{text} fois</span>".html_safe
    end
  end
end
