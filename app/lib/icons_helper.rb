# frozen_string_literal: true

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

  def get_random_png_icon(path)
    image = extract_icons(1, path).first
    "icons/#{path}/#{image}"
  end

  def get_png_image_path(path, name)
    "icons/#{path}/#{name}"
  end

  def random_next_season_image
    path = "png/seasons/#{next_season}"
    get_random_png_icon(path)
  end

  def random_current_season_image
    path = "png/seasons/#{current_season}"
    get_random_png_icon(path)
  end

  def random_season_image(a_date)
    a_date ||= Date.today - 6.months
    path = "png/seasons/#{season_at(a_date)}"
    get_random_png_icon(path)
  end
end
