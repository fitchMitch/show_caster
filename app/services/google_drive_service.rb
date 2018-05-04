require 'google/api_client/client_secrets'
require 'google/apis/drive_v3'

class GoogleDriveService

  def initialize(current_user)
      configure_client(current_user)
  end

  # def set_session
  #   @drive_session = GoogleDrive::Session.from_credentials(credentials)
  # end

  def configure_client(current_user)
    client_secrets = Google::APIClient::ClientSecrets.new(
      {"installed" =>
        { "access_token" => current_user.token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV['GOOGLE_CLIENT_ID'],
          "client_secret" => ENV['GOOGLE_CLIENT_SECRETS'],
        }
      }
    )
    @service = Google::Apis::DriveV3::DriveService.new
    # TODO V3
    @service.authorization = client_secrets.to_authorization
    @service.authorization.refresh!
    @service
  end
  def file_list
    @service.list_files.files
  end
end
