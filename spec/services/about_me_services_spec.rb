require 'rails_helper'
RSpec.describe 'AboutMeService', type: :service do
  let!(:about_service) { AboutMeService.new }
  let!(:now) { Time.zone.now }
  describe '#next_show' do
    let!(:performance0) do
      create(:performance_with_actors, event_date: now + 3.days)
    end
    let!(:performance) do
      create(:performance_with_actors, event_date: now + 2.days)
    end
    let!(:performance2) do
      create(:performance_with_actors, event_date: now - 2.days)
    end
    it 'should return user\'s next show' do
      user1_id = performance.actors.first.user_id
      result = about_service.next_show(user1_id)
      expect(result).to eq(performance)
    end
    it 'should return empty when show\'s in the passed' do
      user2_id = performance2.actors.first.user_id
      expect(about_service.next_show(user2_id)).to include(
        "Aucun spectacle prévu"
      )
    end
  end

  describe '#previous_show' do
    let!(:performance0) do
      create(:performance_with_actors, event_date: now - 3.days)
    end
    let!(:performance) do
      create(:performance_with_actors, event_date: now + 2.days)
    end
    let!(:performance2) do
      create(:performance_with_actors, event_date: now - 2.days)
    end
    it 'should return user\'s previous show' do
      user2_id = performance2.actors.first.user_id
      result = about_service.previous_show(user2_id)
      expect(result).to eq(performance2)
    end
    it 'should return empty when show\'s in the passed' do
      user_id = performance.actors.first.user_id
      result = about_service.previous_show(user_id)
      expect(result).to eq(I18n.t('performances.no_passed_show'))
    end
  end

  describe '#next_course' do
    let!(:course) { create(:course, event_date: now - 3.days) }
    context 'when no course in the future' do
      it 'should give next show date and link of course 1' do
        result = about_service.next_course
        expect(result).to eq(I18n.t('courses.no_future_course'))
      end
    end
    context 'when some course in the future' do
      let!(:course1) { create(:course, event_date: now + 2.days) }
      let!(:course2) { create(:course, event_date: now + 4.days) }
      subject { about_service.next_course }
      it 'should give next show date and link of course 1' do
        expect(subject).to eq(course1)
      end
    end
  end

  describe '#last_comments' do
    let!(:poll_opinion_thread) { create(:poll_opinion_thread) }
    let!(:user) { poll_opinion_thread.comments.first.creator }
    it 'should list last comments of threads' do
      user.former_connexion_at = Time.zone.now - 2.years
      subject = about_service.last_comments(user)
      expect(subject.is_a?(Array)).to be true
      expect(subject.first.is_a?(Commontator::Comment)).to be(true)
      expect(subject.count).to be >= 1
    end
  end

  describe '#last_poll_results' do
    let!(:poll_opinion) { create(:poll_opinion, expiration_date: (now - 2.days)) }
    subject { about_service.last_poll_results(user) }
    context 'when one poll has expired and a user not connected for 10 days' do
      let!(:user) { create(:user, last_sign_in_at: now - 10.days) }
      it 'should count a single result' do
        expect(subject.count).to eq(1)
      end
    end
    context 'when one poll has expired and a user not connected for 10 days' do
      let!(:user) { create(:user, last_sign_in_at: now - 1.days) }
      it 'should count a single result' do
        expect(subject.count).to eq(0)
      end
    end
  end
end
