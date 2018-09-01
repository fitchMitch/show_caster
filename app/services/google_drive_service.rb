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
    @service.authorization = client_secrets.to_authorization
    @service.authorization.refresh!
    @service
  end
  def file_list
    # @service.list_files.files
    # Photos : https://drive.google.com/open?id=0B3Djw_z2qYLeRHFQMHlCd0VQc28
    # photo_folder_id = "0B3Djw_z2qYLedURtLVV4Mm9RVjA" # This is the Photos id, I think
    # photo_folder_id = "0B3Djw_z2qYLea0NyNmQwZnFqUWs" # This is the Photos id, I think
    # q = "mimeType='image/jpeg' and sharedWithMe=true and '#{photo_folder_id}' in parents"
    # q = "sharedWithMe=true and mimeType='application/vnd.google-apps.folder' and '0B3Djw_z2qYLea0NyNmQwZnFqUWs' in parents"
    q = "sharedWithMe=true and mimeType='application/vnd.google-apps.folder'"
    files =   @service.fetch_all(items: :files) do |page_token|
        @service.list_files(
          q: q,
          spaces: 'drive',
          fields: 'nextPageToken, files(id, name, parents)',
          page_token: page_token)
    end


  end
end
