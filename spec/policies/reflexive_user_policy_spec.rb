require 'rails_helper'
RSpec.describe UserPolicy do
  subject { UserPolicy.new(user, user)}

  let!(:admin){ create(:user, :admin, :registered, email:"shaolin@wang.fr")}
  let!(:admin2){ create(:user, :admin, :registered, email:"shaolin2@wang.fr")}

  context "As a visitor" do
    let(:user) { nil }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     forbid_action(:index) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     forbid_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
  end

  context "As a player" do
    let(:user) { FactoryBot.create(:user, :player, :registered) }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
  end

  context "As an admin_com" do
    let(:user) { FactoryBot.create(:user, :admin_com, :registered) }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     permit_action(:promote) }
  end

  context "As an admin" do
    let(:user) { FactoryBot.create(:user, :admin, :registered) }
    it { is_expected.to     permit_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     permit_action(:promote) }
  end
end
