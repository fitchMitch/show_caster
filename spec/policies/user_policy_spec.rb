require 'rails_helper'
RSpec.describe UserPolicy do
  let!(:another_user){ create(:user, :player, :registered, email:"sholina@wang.fr")}
  subject { UserPolicy.new(user, another_user)}

  let!(:admin){ create(:user, :admin, :registered, email:"shaolin@wang.fr")}

  context "As a visitor" do
    let(:user) { nil }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     forbid_action(:index) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     forbid_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
    it { is_expected.to     forbid_action(:show_last_connexion) }
  end

  context "As a player" do
    let(:user) { FactoryBot.create(:user, :player, :registered) }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     forbid_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
    it { is_expected.to     forbid_action(:show_last_connexion) }
  end

  context "As an admin_com" do
    let(:user) { FactoryBot.create(:user, :admin_com, :registered) }
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     forbid_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
    it { is_expected.to     forbid_action(:show_last_connexion) }
  end

  context "As an admin" do
    let(:user) { FactoryBot.create(:user, :admin, :registered) }
    it { is_expected.to     permit_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     permit_action(:promote) }
    it { is_expected.to     permit_action(:show_last_connexion) }
  end
end
