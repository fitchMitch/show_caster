module UsersHelper
  #require 'nokogiri'
  include IconsHelper
  include SeasonsHelper
  include LoggingHelper

  # Returns the Gravatar for the given user.
  # def gravatar_for(user, options = { size: 60 })
  #   gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  #   size = options[:size]
  #   gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  #   image_tag(gravatar_url, alt: user.full_name, class: 'gravatar')
  # end

  def link_to_user(user, current_user)
    if current_user?(user) || current_user.admin?
    # TODO ?if ( current_user?(user) || current_user.admin?) && policy(user).edit?
      if user.archived?
        link_to user.full_name, user_path(user).html_safe
      else
        "<strong>#{link_to user.full_name, user_path(user)}</strong>".html_safe
      end
    else
      user.full_name
    end
  end

  def current_user?(user)
    current_user.id == user.id
  end

  def status_label(user)
    user.status = :archived if user.status.nil?
    label_hash = {
      invited: {
        klass: 'warning',
        text: t('users.state.invited')
      },
      googled: {
        klass: 'info',
        text: t('users.state.processing')
      },
      archived: {
        klass: 'default',
        text: t('users.state.rip')
      },
      setup: {
        klass: 'danger',
        text: t(
          'users.state.to_invite', firstname: user.firstname
        ),
        link: 'to_user'
      }
    }
    sym_status = user.status.to_sym
    label_hash = label_hash[sym_status]
    if sym_status == :registered
      user.role_i18n
    elsif label_hash[:link].nil?
      "<span class=\"label label-#{label_hash[:klass]}\">" \
      "#{label_hash[:text]}</span>".html_safe
    else
      render partial: 'show_invite_button', locals: { user: user }
    end
  end

  def badge_user(user)
    colors = user.color.partition(';')
    "border: 4px #{colors[2]} solid; color:#{colors[0]}".html_safe
  end

  def badge_user_from_id(user_id)
    user = User.find_by_id(user_id)
    "<span class='badge_user' style='#{badge_user(user)}'>" \
    "#{user.firstname} #{user.lastname.first}</span>".html_safe
  end

  def sesame_picture_url(user)
    if user.pictures && user.pictures.first && user.pictures.first.photo
      user.pictures.first.photo(:square)
    else
      user.photo_url || image_url('Zoidberg.png')
    end
  end

  def badge_user_for_comment(user, size = 60)
    square_size = "#{size}x#{size}"
    in_dallas = "border: 3px solid black;
                 border-color: #{user.hsl_user_color2};
                 "
    image_tag sesame_picture_url(user),
              size: square_size,
              class: 'in-dallas',
              style: in_dallas
  end

  def display_avatar_list
    res = ''
    extract_icons(User.active.count, 'png/characters').each do |file|
      res += image_tag("icons/png/characters/#{file}", size: 35).html_safe
    end
    res
  end

  def event_date_link(obj)
    return obj unless obj.respond_to?(:event_date)
    start = obj.event_date > Time.zone.now ? 'Dans' : 'Il y a'
    wording_for_future = "#{start} #{time_ago_in_words(obj.event_date)}"
    if obj.type == 'Course'
      link_to wording_for_future, courses_path
    elsif obj.type == 'Performance'
      link_to wording_for_future, performance_path(obj)
    else
      raise ArgumentError
    end
  rescue ArgumentError => e
    warn_logging(e)
    Bugsnag.notify(e)
  end

  def random_next_season_image
    season_path = "png/seasons/#{next_season}"
    image = extract_icons(1, season_path).first
    "icons/#{season_path}/#{image}"
  end

  def random_current_season_image
    season_path = "png/seasons/#{current_season}"
    image = extract_icons(1, season_path).first
    "icons/#{season_path}/#{image}"
  end
end
