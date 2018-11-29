require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'

class GoogleCalendarService
  attr_accessor :calendar

  def initialize(current_user)
    configure_client(current_user)
  end

  def configure_client(current_user)
    client_secrets = Google::APIClient::ClientSecrets.new(
      {
        'installed' => {
          'access_token' => current_user.token,
          'refresh_token' => current_user.refresh_token,
          'client_id' => ENV['GOOGLE_CLIENT_ID'],
          'client_secret' => ENV['GOOGLE_CLIENT_SECRETS']
        }
      }
    )
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = client_secrets.to_authorization
    @calendar.authorization.refresh!
    @calendar
  end

  def calendar_list
    @calendar.list_calendar_lists
  end

  def add_to_google_calendar(event)
    event = make_a_google_event(event.google_event_params)
    @calendar.insert_event company_calendar_id,
                           event,
                           send_notifications: true
  end

  def existing_event?(id)
    response = @calendar.get_event(company_calendar_id, id)
    response.id == id
  rescue
    Rails.logger.warn("Calendar id fails here : #{id}")
    false
  end

  def update_google_calendar(event)
    opt = event.google_event_params
    fk = opt.fetch(:fk, nil)
    if fk.nil? || fk == ''
      msg = 'Inexisting Google Calendar event'
      Rails.logger.info(msg)
      msg
    elsif existing_event? opt[:fk]
      @calendar.update_event company_calendar_id,
                             opt[:fk],
                             make_a_google_event(opt)
    else
      Rails.logger.debug(
        "missing event in Google Calendar with id: #{opt[:fk]}"
      )
    end
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.warn(
      "API Call failed with #{$ERROR_INFO} \n" \
      "in update_event_google_calendar | #{e}"
    )
  end

  def delete_google_calendar(event)
    if !event.try(:fk).nil? && existing_event?(event.fk)
      @calendar.delete_event(company_calendar_id, event.fk)
    else
      Rails.logger.warn(
        "fails to delete from GCalendar event id/fk:" \
        " #{event.id} / #{event.fk}"
      )
      nil
    end
  rescue
    Bugsnag.notify($ERROR_INFO)
    Rails.logger
         .debug(
           "API Call failed with #{$ERROR_INFO} \n" \
           "in delete_event_google_calendar"
         )
    nil
  end

  def make_a_google_event(opt)
    # event_title  = "events.#{opt.fetch(:title, 'g_title.performance')}"
    event_hash = {
      summary: opt.fetch(:title, 'Show'),
      location: opt.fetch(:location, I18n.t('performances.nowhere')),
      description: I18n.t(
        'performances.mere_new_opus',
        name: opt.fetch(:theater_name)
      ),
      start: {
        date_time: opt.fetch(:event_date, nil),
        time_zone: 'Europe/Paris'
      },
      end: {
        date_time: opt.fetch(:event_end, nil),
        time_zone: 'Europe/Paris'
      },
      attendees: opt.fetch(:attendees_email, []),
      reminders: {
        override: [
          { method: 'email', minutes: 2 * 24 * 60 },
          { method: 'popup', minutes: 8 * 60 }
        ],
        use_default: false
      }
    }
    event_hash[:id] = opt[:fk] if opt.key?('fk')
    Google::Apis::CalendarV3::Event.new(event_hash)
  end

  def self.token_user_information(user, access_token)
    data = access_token[:info]
    credentials = access_token[:credentials]
    firstname = data[:first_name].nil? ? user.firstname : data[:first_name]
    lastname = data[:last_name].nil? ? user.lastname : data[:last_name].upcase
    from_token = {
      firstname: firstname,
      lastname: lastname,
      email: data[:email].downcase,
      provider: access_token[:provider],
      uid: access_token[:uid],
      photo_url: data[:image],
      token: credentials[:token],
      refresh_token: credentials[:refresh_token],
      expires_at: Time.at(credentials[:expires_at].to_i).to_datetime
    }
    # Additional attributes
    from_token[:status] = :googled if user.setup? || user.invited?
    from_token[:former_connexion_at] = user.last_sign_in_at
    from_token[:last_sign_in_at] = Time.zone.now
    from_token
  end

  private

  def company_calendar_id
    ENV['GOOGLE_CALENDAR_ID']
  end
end
