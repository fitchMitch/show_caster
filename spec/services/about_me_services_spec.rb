require 'rails_helper'
RSpec.describe 'AboutMeService', type: :service do
  let!(:now) { Time.zone.now }

  let!(:performance0) do
    create(:performance_with_actors, event_date: now + 3.days)
  end
  let!(:about_service0) { AboutMeService.new(performance0.actors.first.user) }

  let!(:performance2) do
    create(:performance_with_actors, event_date: now - 2.days)
  end
  let!(:about_service2) { AboutMeService.new(performance2.actors.first.user) }

  describe '#next_show' do
    it { expect(about_service0.next_show).to eq(performance0) }
    it { expect(about_service2.next_show).to include('Aucun spectacle prévu') }
  end

  describe '#previous_show' do
    it { expect(about_service0.previous_show).to eq(I18n.t('performances.no_passed_show')) }
    it { expect(about_service2.previous_show).to eq(performance2) }
  end

  describe '#next_course' do
    let(:course) { create(:course, event_date: now - 3.days) }
    let(:about_course) { AboutMeService.new(course.user) }
    context 'when no course in the future' do
      it 'should give next show date and link of course 1' do
        expect(about_course.next_course).to eq(I18n.t('courses.no_future_course'))
      end
    end
    context 'when some course in the future' do
      let!(:course1) { create(:course, event_date: now + 2.days) }
      let!(:course2) { create(:course, event_date: now + 4.days) }
      subject { about_course.next_course }
      it 'should give next show date and link of course 1' do
        expect(subject).to eq(course1)
      end
    end
  end

  describe '#last_comments' do
    let!(:poll_opinion_thread) { create(:poll_opinion_thread) }
    let!(:user) { poll_opinion_thread.comments.first.creator }
    let(:about_poll_service) { AboutMeService.new(user) }
    it 'should list last comments of threads' do
      user.former_connexion_at = Time.zone.now - 2.years
      subject = about_poll_service.last_comments
      expect(subject.is_a?(Array)).to be true
      expect(subject.first.is_a?(Commontator::Comment)).to be(true)
      expect(subject.count).to be >= 1
    end
  end

  describe '#last_poll_results' do
    let!(:poll_opinion) { create(:poll_opinion, expiration_date: (now - 2.days)) }
    context 'when one poll has expired and a user not connected for 10 days' do
      let!(:user) { create(:user, last_sign_in_at: now - 10.days) }
      let(:about_poll_service) { AboutMeService.new(user) }
      it 'should count a single result' do
        expect(about_poll_service.last_poll_results.count).to eq(1)
      end
    end
    context 'when one poll has expired and a user not connected for 1 day' do
      let!(:user) { create(:user, last_sign_in_at: now - 1.days) }
      let(:about_poll_service) { AboutMeService.new(user) }
      it 'should count a single result' do
        expect(about_poll_service.last_poll_results.count).to eq(0)
      end
    end
  end
end
