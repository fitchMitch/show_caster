module EventsHelper
  def get_duration(val)
    r = Event::DURATIONS.rassoc(val)
    r.nil? ? "" : r[0]
  end

  def get_progress(event)
    states = {
      draft: "label-default",
      finalized: "label-info",
      sent_to_media_1: "label-warning",
      ok_with_media_1: "label-success"
    }
    label_color = states.fetch event.progress.to_sym, "label-danger"

    "<span class='label #{label_color}'> #{event.progress_i18n} </span>".html_safe
  end

  def short_label_helper(event_id)
    event = Event.find_by(id: event_id)
    "<span class='label label-success'> #{event.theater.theater_name[0,25]}</span> <strong>#{event.event_date.strftime('%d-%b %Y')}</strong> | #{event.title[0,35]}".html_safe
  end

  def photo_indicator(event)
    unless event.photo_count.zero?
      "<span class='light-frame'><small>#{event.photo_count}</small>  #{fa_icon('image')}</span>".html_safe
    end
  end
end
