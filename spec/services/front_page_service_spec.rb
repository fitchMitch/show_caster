require 'rails_helper'
RSpec.describe FrontPageService, type: :service do
  let!(:fps) { described_class.new }
  describe '#next_performances' do
    before do
      6.times { create :performance_with_actors }
    end
    it 'should show 5 performances maximum' do
      expect(fps.next_performances.count).to eq 5
    end
    it 'should be ordered by performance_date' do
      expect(fps.next_performances.to_a[0..4].each_cons(2).all? do |a, b|
        a.event_date <= b.event_date
      end).to be true
    end
    it 'events should be set in the ' do
      5.times do
        create(:performance_with_actors, event_date: Time.zone.now - 2.days)
      end
      expect(fps.next_performances.to_a.all? do |event|
        event.event_date >= Time.zone.now
      end).to be true
    end
  end

  describe '#players_on_stage' do
    let!(:performance_with_actors) { create(:performance_with_actors_standard) }
    it 'it should list 6 firstnames' do
      expect(fps.players_on_stage(performance_with_actors).count).to eq(6)
    end
    it 'last_name is the mc\'s name' do
      actor_found = performance_with_actors.actors.find do |actor|
        actor.stage_role == 'mc'
      end
      expect(
        fps.players_on_stage(performance_with_actors).last
      ).to eq(actor_found.user.firstname)
    end
  end

  describe '#photo_list' do
    subject(:photo_list) { described_class.new.photo_list(n_shows, m_pictures) }
    let(:n_shows) { 2 }
    let(:m_pictures) { 5 }
    context 'with no show' do
      it { expect(photo_list).to be(nil) }
    end

    context 'with not enough shows' do
      let(:show1) { double('show1') }
      let!(:shows) { [show1] }
      let(:performance) { double('performance') }
      before :each do
        allow(Performance).to receive(:passed_events) { performance }
        allow(performance).to receive(:public_events) { performance }
        allow(performance).to receive(:limit) { shows }
        allow(Picture).to receive(:last_pictures) do
          [
          'photo1.JPG',
          'photo2.jpg',
          'photo3.PNG',
          'photo4.png'
          ]
        end
      end
      it { expect(photo_list).not_to be(nil) }
      it { expect(photo_list.sample.split(".").last).to match(/jpg|png/i) }
      it { expect(photo_list.count).to eq(4) }
    end
    context 'with many pictures' do
      let(:show1) { double('show1') }
      let(:show2) { double('show2') }
      let(:show3) { double('show3') }
      let!(:shows) { [show1, show2, show3] }
      let(:performance) { double('performance') }
      before :each do
        allow(Performance).to receive(:passed_events) { performance }
        allow(performance).to receive(:public_events) { performance }
        allow(performance).to receive(:limit) { shows }
        allow(Picture).to receive(:last_pictures).with(show1, m_pictures) do
          [
            'photo1.JPG',
            'photo2.jpg',
            'photo3.PNG',
            'photo4.png'
          ]
        end
        allow(Picture).to receive(:last_pictures).with(show2, m_pictures) do
          ['photo5.JPG']
        end
        allow(Picture).to receive(:last_pictures).with(show3, m_pictures) do
          ['photo6.JPG']
        end
      end
      it { expect(photo_list.count).to eq(5) }
    end

    context 'with some private show pictures' do
      let(:show1) { double('show1') }
      let(:show2) { double('show2', private_event: true) }
      let(:show3) { double('show3') }
      let!(:shows) { [show1, show3] }
      let(:performance) { double('performance') }
      before :each do
        allow(Performance).to receive(:passed_events) { performance }
        allow(performance).to receive(:public_events) { performance }
        allow(performance).to receive(:limit) { shows }
        allow(Picture).to receive(:last_pictures).with(show1, m_pictures) do
          [
            'photo1.JPG',
            'photo2.jpg',
            'photo3.PNG',
            'photo4.png'
          ]
        end
        allow(Picture).to receive(:last_pictures).with(show2, m_pictures) do
          ['photo5.JPG']
        end
        allow(Picture).to receive(:last_pictures).with(show3, m_pictures) do
          ['photo6.JPG']
        end
      end
      it { expect(photo_list.include?('photo5.JPG')).to be false }
    end
  end
end
