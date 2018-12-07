require 'rails_helper'
# require 'icons_helper'
RSpec.describe SeasonsHelper do
  describe '.current_season' do
    context 'this is spring time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 3, 29) }
      end
      it 'should return spring' do
        expect(UsersController.current_season).to eq('spring')
      end
    end
    context 'this is winter time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 12, 29) }
      end
      it 'should return winter' do
        expect(UsersController.current_season).to eq('winter')
      end
    end
  end

  describe '.next_season' do
    context 'this is spring time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 3, 29) }
      end
      it 'it returns spring' do
        expect(UsersController.next_season).to eq('summer')
      end
    end
    context 'this is winter time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 12, 29) }
      end
      it 'it returns winter' do
        expect(UsersController.next_season).to eq('spring')
      end
    end
  end
end
