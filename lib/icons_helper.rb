# getting random icons from images
module IconsHelper
  def extract_icons(number, path)
    full_path = "app/assets/images/icons/#{path}/*.png"
    images_full_path = Dir[Rails.root.join(full_path)]
    images_full_path.map! { |file| file.split('/').last }
    number == 1 ? images_full_path.first : images_full_path.sample(number)
  rescue StandardError => e
    Rails.logger.error(" Icon extraction failed with : #{e}")
    Bugsnag.notify("icon extraction error with #{e}")
  end

  def get_random_png_icon(path)
    image = extract_icons(1, path)
    "icons/#{path}/#{image}"
  end

  def get_png_image_path(path, name)
    "icons/#{path}/#{name}"
  end
end
