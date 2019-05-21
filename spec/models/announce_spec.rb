require 'rails_helper'

RSpec.describe Announce, type: :model do

  it { should belong_to(:author) }
  it { should validate_presence_of(:expiration_date) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3) }
  it { should validate_length_of(:title).is_at_most(40) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_length_of(:body).is_at_most(250) }

  describe 'scope active' do
    describe 'when announce is expired' do
      let!(:expired_announce) {
        create(:announce, expiration_date: Time.zone.now.prev_year)
      }
      it { expect(Announce.active.count).to eq(0) }
    end
    describe 'when announce is not expired' do
      let!(:unexpired_announce) {
        create(:announce, expiration_date: Time.zone.now.next_year)
      }
      it { expect(Announce.active.count).to eq(1) }
    end
  end

end
