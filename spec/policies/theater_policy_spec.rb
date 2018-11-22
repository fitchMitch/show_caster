require 'rails_helper'
RSpec.describe TheaterPolicy do
  subject { TheaterPolicy.new(user, theater)}
  let!(:theater) { theater = FactoryBot.create(:theater) }

  context "As a visitor" do
    let!(:user) { nil }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     forbid_action(:index) }
    it { is_expected.to     forbid_action(:show) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:destroy) }
  end

  context "As a player" do
    let!(:user) { FactoryBot.create(:user, :player,:registered) }

    subject { TheaterPolicy.new(user, theater)}
    it { is_expected.to      forbid_action(:new) }
    it { is_expected.to      permit_action(:index) }
    it { is_expected.to      permit_action(:show) }
    it { is_expected.to      forbid_action(:edit) }
    it { is_expected.to      forbid_action(:update) }
    it { is_expected.to      forbid_action(:destroy) }
  end

  context "As an admin_com" do
    let!(:user) { FactoryBot.create(:user,:admin_com,:registered) }

    subject { TheaterPolicy.new(user, theater)}
    it { is_expected.to     permit_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     forbid_action(:destroy) }
  end
  
  context "As an admin" do
    let!(:user) { FactoryBot.create(:user, :admin,:registered) }

    subject { TheaterPolicy.new(user, theater)}
    it { is_expected.to     permit_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     forbid_action(:destroy) }
  end
end
