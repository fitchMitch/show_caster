require 'rails_helper'
# require 'icons_helper'
RSpec.describe IconsHelper do
  describe '.extract_icons' do
    let(:a_path) { 'png/characters' }
    let(:number) { (1..3).to_a.sample }
    it 'should return an Array with a number of items' do
      res = UsersController.extract_icons(number, a_path)
      expect(res.is_a?(Array)).to be true
      expect(res.count).to eq(number)
    end
    it 'should return an Array of png items' do
      res = UsersController.extract_icons(number, a_path)
      expect(res.all? do |file|
        File.extname(file) == '.png'
      end).to be true
    end
  end
end
