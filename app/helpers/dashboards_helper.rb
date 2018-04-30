module DashboardsHelper
  def translate(key)
    expr = I18n.t("dashboards.#{key}")
  end

  def show_perf(reci)
    my = reci[0]
    av = reci [1]
    text = my.nil? ? "0" : "#{my}"
    if my.to_i <= av.to_i
      "<button class='label label-success'> \
      => <span class='badge'>#{text} x</span></span>".html_safe
    else
      "<button class='label label-danger'> \
      <span class='badge'>#{text} x</span></span>".html_safe
    end
  end
end
