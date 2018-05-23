module PicturesHelper
  def back_path(object)
    klass = pluralize 2,object.class.name.downcase
    "#{klass}_path"
  end
end
