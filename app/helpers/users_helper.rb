module UsersHelper
  require 'nokogiri'
  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 60 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: 'gravatar')
  end

  def link_to_user(user, current_user)
    if(user.id == current_user.id) || current_user.admin?
      "#{link_to user.full_name, user_path(user)}".html_safe
    else
      user.full_name
    end
  end

  def current_user?(user)
    #Is current user known here ?
    current_user.id == user.id
  end

  def status_label(user)
    label_hash = case user.status.to_sym
    when :invited
      {klass: "warning",
      text: "Invité"}
    when :googled
      {klass: "info",
      text: "En cours ?"}
    when :archived
      {klass: "default",
      text: "a quitté la compagnie"}
    else
      {klass: "danger",
      text: "A inviter ..."}
    end
    if user.status.to_sym == :registered
      user.role_i18n
    else
      "<span class=\"label label-#{label_hash[:klass]}\">#{label_hash[:text]}</span>".html_safe
    end
  end

  def badge_user(user,role=nil)
    colors = user.member.color.partition(";")
    "border: 4px #{colors[2]} solid; color:#{colors[0]}".html_safe
  end

  def badge_user_from_id(user_id,role=nil)
    user = User.find_by_id(user_id)
    "<span class='badge_user' style='#{badge_user(user, role)}'> \
    #{user.firstname} #{user.lastname.first}</span>".html_safe
  end
end
