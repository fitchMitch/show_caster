module AttributesMatcher
  def attr_matcher(obj, hash_attribute)
    hash_attribute.each do |k, v|
      expect(obj.send(k.to_sym)).to eq(v)
    end
  end
end
