require 'rails_helper'
# require 'icons_helper'
RSpec.describe SeasonsHelper do
  describe '.what_season_today' do
    context 'this is spring time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 3, 29) }
      end
      it 'should return spring' do
        expect(CommitteesController.what_season_today).to eq('spring')
      end
    end
    context 'this is winter time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 12, 29) }
      end
      it 'should return winter' do
        expect(CommitteesController.what_season_today).to eq('winter')
      end
    end
  end
end
