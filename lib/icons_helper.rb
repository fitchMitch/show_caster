# getting random icons from images
module IconsHelper
  def extract_icons(number, path)
    full_path = "app/assets/images/icons/#{path}/*.png"
    images_full_path = Dir[Rails.root.join(full_path)]
    images_full_path.map! { |file| file.split('/').last }
    images_full_path.sample(number)
  rescue StandardError => e
    Rails.logger.error(" Icon extraction failed with : #{e}")
    Bugsnag.notify("icon extraction error with #{e}")
  end
end
