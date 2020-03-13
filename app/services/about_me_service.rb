# frozen_string_literal: true

class AboutMeService
  def initialize(user)
    @user = user
  end

  def next_show
    shows = Performance.next_shows(@user.id)
    if shows.empty?
      verbose = (1..7).to_a.sample < 2
      if verbose
        I18n.t('performances.no_future_comment')
      else
        I18n.t('performances.no_future_show')
      end
    else
      shows.first
    end
  end

  def previous_show
    shows = Performance.previous_shows(@user.id)
    if shows.empty?
      I18n.t('performances.no_passed_show')
    else
      shows.first
    end
  end

  def previous_show_date
    previous_show.is_a?(Performance) ? previous_show.event_date : nil
  end

  def next_course
    courses = Course.next_courses
    if courses.empty?
      I18n.t('courses.no_future_course')
    else
      courses.first
    end
  end

  def last_comments
    last_comments = []
    thread_id_list = Commontator::Thread.last_comments(@user)
    thread_id_list.each do |thread_id|
      last_comments << Commontator::Comment.last_comments(thread_id).first
    end
    last_comments
  end

  def last_poll_results
    Poll.last_results(@user)
  end
end
