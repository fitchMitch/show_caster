require 'rails_helper'

RSpec.describe Notification, type: :service do
  subject { described_class.short_notice?(delay)}
  describe '.short_notice?' do
    context 'when to short' do
      before do
        allow(described_class).to receive(:too_short_notice_days) { 2.days }
      end
      let(:delay) { 1.days.to_i }
      it { expect(subject).to be(true) }
    end
    context 'when not to short' do
      before do
        allow(described_class).to receive(:too_short_notice_days) { 2.days }
      end
      let(:delay) { 3.days.to_i }
      it { expect(subject).to be(false) }
    end
  end
end
