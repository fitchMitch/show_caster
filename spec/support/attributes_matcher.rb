module AttributesMatcher
  def attr_matcher(obj, hash_attribute)
    hash_attribute.each do |k, v|
      expect(obj.send(k.to_sym)).to eq(v)
    end
  end
  def page_attr_matcher(obj, attribute_list)
    attribute_list.each do |attr|
      attr = attr.to_sym
      expect(page.body).to have_content obj.send(attr)
    end
  end
end
