require 'spec_helper'
RSpec.describe UserPolicy do
  context "As a visitor" do
    subject { UserPolicy.new(nil,nil)}
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     forbid_action(:index) }
    it { is_expected.to     forbid_action(:update) }
    it { is_expected.to     forbid_action(:edit) }
    it { is_expected.to     forbid_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
  end

  context "As a player" do
    let(:player) { player = FactoryBot.create(:user, :player, :registered) }
    subject { UserPolicy.new(player, player)}
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     forbid_action(:promote) }
  end

  context "As an admin_com" do
    let(:admin) { player = FactoryBot.create(:user, :admin_com, :registered) }
    subject { UserPolicy.new(admin, admin)}
    it { is_expected.to     forbid_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     permit_action(:promote) }
  end

  context "As an admin" do
    let(:admin) { player = FactoryBot.create(:user, :admin, :registered) }
    subject { UserPolicy.new(admin, admin)}
    it { is_expected.to     permit_action(:new) }
    it { is_expected.to     permit_action(:index) }
    it { is_expected.to     permit_action(:update) }
    it { is_expected.to     permit_action(:edit) }
    it { is_expected.to     permit_action(:show) }
    it { is_expected.to     forbid_action(:destroy) }
    it { is_expected.to     permit_action(:promote) }
  end
end
