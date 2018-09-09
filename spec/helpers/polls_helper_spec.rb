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
  end

  describe '#panel_question' do
    let!(:poll_date) { create(:poll_date_with_answers) }
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
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
  end
end
