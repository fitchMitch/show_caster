require 'rails_helper'
# require 'icons_helper'
RSpec.describe IconsHelper do
  let(:dummy_class) { Class.new { include IconsHelper } }
  let(:a_path) { 'png/characters' }
  describe '.extract_icons' do
    let(:number) { (1..2).to_a.sample }
    it 'should return an Array with a number of items' do
      res = dummy_class.new.extract_icons(number, a_path)
      expect(res.is_a?(Array)).to be(true)
      expect(res.count).to eq(number)
    end
    it 'should return an Array of png items' do
      res = dummy_class.new.extract_icons(number, a_path)
      expect(res.all? do |file|
        File.extname(file) == '.png'
      end).to be true
    end
  end

  describe 'get_random_png_icon' do
    it 'should render a png' do
      res = dummy_class.new.get_random_png_icon(a_path)
      expect(res[-4..-1]).to eq('.png')
    end
    it 'should render a image with submitted path' do
      res = dummy_class.new.get_random_png_icon(a_path)
      expect(res).to include('icons')
      expect(res).to include(a_path)
    end
  end
end
