require 'rails_helper'

RSpec.describe Announce, type: :model do

  it { should belong_to(:author) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:time_start) }
  it { should validate_presence_of(:time_end) }
  it { should validate_length_of(:title).is_at_least(3) }
  it { should validate_length_of(:title).is_at_most(40) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_length_of(:body).is_at_most(250) }

  describe 'scope shown_as_active' do
    context 'when wayyy before it shall not appear' do
      let!(:announce) do
        create(
          :announce,
          time_start: Time.zone.now + 2.month,
          time_end: Time.zone.now + 3.month
        )
      end
      it { expect(described_class.shown_as_active.count).to eq(0)  }
    end
    context 'when before it shall appear' do
      let!(:announce) do
        create(
          :announce,
          time_start: Time.zone.now + 10.days,
          time_end: Time.zone.now + 3.month
        )
      end
      it { expect(described_class.shown_as_active.count).to eq(1)  }
    end
    context 'when during event it shall appear' do
      let!(:announce) do
        create(
          :announce,
          time_start: Time.zone.now - 10.days,
          time_end: Time.zone.now + 3.month
        )
      end
      it { expect(described_class.shown_as_active.count).to eq(1)  }
    end
  end

end
