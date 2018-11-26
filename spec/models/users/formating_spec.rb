require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe Answer, type: :model do
  context 'validations' do
    let(:user) { create(:user) }

    describe '#pick_color' do
      subject { user.pick_color }
      it 'should return 2 colors' do
        color1, color2 = subject.split(';')
        expect(color1.start_with?('hsl')).to be_truthy
        expect(color2.start_with?('hsl')).to be_truthy
        numbers_inside1 = color1[4..-2].split(',')
        numbers_inside2 = color2[4..-2].split(',')
        left_first = numbers_inside1[0].to_i
        left_second = numbers_inside1[1].chomp.to_i
        left_third = numbers_inside1[2].chomp.to_i
        right_first = numbers_inside2[0].to_i
        right_second = numbers_inside2[1].chomp.to_i
        right_third = numbers_inside2[2].chomp.to_i

        expect([left_first, 70, 340].sort[1]).not_to eq(left_first)
        expect([left_second, 36, 76].sort[1]).to eq(left_second)
        expect([left_third, 76, 95].sort[1]).to eq(left_third)
        expect([right_first, 70, 340].sort[1]).not_to eq(right_first)
        expect([right_second, 66, 100].sort[1]).to eq(right_second)
        expect([right_third, 32, 50].sort[1]).to eq(right_third)
      end
    end

    describe '#first_and_last_name' do
      let(:user) { build(:user, firstname: 'Gala', lastname: 'Louxor') }
      subject { user.first_and_last_name }
      it { is_expected.to eq 'Gala LOUXOR' }
    end

    describe '#first_and_l' do
      let!(:user) { create(:user, firstname: 'Gala', lastname: 'Louxor') }
      context 'with a single Gala' do
        subject { user.first_and_l }
        it { is_expected.to eq 'Gala' }
      end
      context 'with two Gala' do
        let!(:user2) { create(:user, firstname: 'Gala', lastname: 'Arachne') }
        subject { user.first_and_l }
        it { is_expected.to eq 'Gala L' }
      end
    end

    describe '#last_connexion' do
      let(:user) { build :user, last_sign_in_at: Time.zone.now }
      subject { user.last_connexion }
      it { is_expected.to eq 'il y a environ moins d\'une minute' }
    end
  end
end
