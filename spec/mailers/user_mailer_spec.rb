require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "User Mailer new_player_notice_mail" do
    let!(:admin) {create(:user, :admin,:registered)}
    let(:player) {create(:user, :player,:setup)}
    let(:w_mail) { UserMailer.new_player_notice_mail(player).deliver_now }
    let(:url) { "http://localhost:3000/users/#{player.id}" }
    let(:to) { admin.email }

    before :each do
      url  = "http://localhost:3000/users/#{player.id}"
      to = admin.email
    end

    it "should have a correct from" do
      expect(w_mail.from).to eq(["no-reply@etienneweil.fr"])
    end

    it "should have a correct to" do
      expect(w_mail.to.first).to eq(to)
    end

    it "should have a correct subject" do
      expect(w_mail.subject).to eq(I18n.t("devise.invitations.mailer", name: player.full_name))
    end

    it "should have a correct body" do
      expect(w_mail.body.encoded.to_s).to include("#{player.firstname} vient de s'inscrire")
    end

  end

  describe "User Mailer promoted_mail" do
    let(:player) {create(:user, :player,:setup)}
    let(:admin) {create(:user, :admin,:registered)}
    let(:w_mail) { UserMailer.promoted_mail(player).deliver_now }
    let(:url) { "http://localhost:3000/users/#{player.id}" }
    let(:to) { player.email }

    before :each do
      url  = "http://localhost:3000/users/#{player.id}"
      to = admin.email
    end

    it "should have a correct from" do
      expect(w_mail.from).to eq(["no-reply@etienneweil.fr"])
    end

    it "should have a correct to" do
      expect(w_mail.to.first).to eq(to)
    end

    it "should have a correct subject" do
      expect(w_mail.subject).to eq(I18n.t("actors.promoted_mail.subject"))
    end

    it "should have a correct body" do
      expect(w_mail.body.encoded.to_s).to include("L'administrateur vient de changer ton statut sur le site")
    end

  end
end
