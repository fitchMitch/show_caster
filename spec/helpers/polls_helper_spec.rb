require 'rails_helper'

RSpec.describe PollsHelper, type: :helper do
  describe '#poll_date' do
    let!(:nimp) { 'test' }
    let!(:time) { Time.zone.now }
    it 'shall give unchanged expr' do
      expect(helper.poll_date(nimp)).to eq(nimp)
    end
    it 'shall transate a date' do
      expect(helper.poll_date(time)).to eq(I18n.l(time, format: '%a %d %b'))
    end
  end

  describe '#poll_datetime' do
    let!(:nimp) { 'test' }
    let!(:time) { Time.zone.now }
    it 'shall give unchanged expr' do
      expect(helper.poll_datetime(nimp)).to eq(nimp)
    end
    it 'shall transate a date' do
      expect(helper.poll_datetime(time)).to eq(
        I18n.l(time, format: '%a %d %b | %H:%M')
      )
    end
  end

  describe '#answers_list' do
    let!(:poll_date) { create(:poll_date_with_answers) }
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
    let!(:poll_secret_ballot) { create(:secret_ballot_with_answers) }
    let!(:no_poll) { create(:user) }
    it 'shall give a PollOpinion tag' do
      expect(helper.answers_list(poll_opinion)).to include(
        poll_opinion.answers.first.answer_label
      )
    end
    it 'shall give a PollDate tag' do
      expect(helper.answers_list(poll_date).to_s).to include(
        helper.poll_datetime(poll_date.answers.first.date_answer)
      )
    end
    it 'shall give a SecretBallot tag' do
      expect(helper.answers_list(poll_secret_ballot)).to include(
        poll_secret_ballot.answers.first.answer_label
      )
    end
    it 'shall give a SecretBallot tag' do
      expect(helper.answers_list(no_poll)).to be(nil)
    end
  end

  describe '#panel_question' do
    let!(:poll_date) { create(:poll_date_with_answers) }
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
    let!(:poll_secret_ballot) { create(:secret_ballot_with_answers) }
    let!(:no_poll) { create(:user) }
    it 'shall give a panel question to poll date' do
      expect(helper.panel_question(poll_date)).to include(
        poll_date.question
      )
      expect(helper.panel_question(poll_date)).to include('info')
    end
    it 'shall give a panel question to poll opinion' do
      expect(helper.panel_question(poll_opinion)).to include(
        poll_opinion.question
      )
      expect(helper.panel_question(poll_opinion)).to include('warning')
    end
    it 'shall give a panel question to poll opinion' do
      expect(helper.panel_question(poll_secret_ballot)).to include(
        poll_secret_ballot.question
      )
      expect(helper.panel_question(poll_secret_ballot)).to include('danger')
    end
    it 'shall give nil when no poll is submitted' do
      expect(helper.panel_question(no_poll)).to be(nil)
    end
  end

  describe '#link_to_show_poll' do
    let(:poll_opinion) { create(:poll_opinion) }
    let(:poll_date) { create(:poll_date) }
    let(:a_proc) { Proc.new { 'something' } }
    it 'should return a show link' do
      expect(helper.link_to_show_poll(poll_opinion, &a_proc)).to eq(
        "<a href=\"/poll_opinions/#{poll_opinion.id}\">something</a>"
      )
    end
    it 'should return a show link' do
      expect(helper.link_to_show_poll(poll_date, &a_proc)).to eq(
        "<a href=\"/poll_dates/#{poll_date.id}\">something</a>"
      )
    end
  end
end
