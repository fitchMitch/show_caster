require 'rails_helper'
# require 'pundit'

RSpec.describe UsersHelper, type: :helper do
  describe '#link_to_user in index page' do
    let!(:admin)           { create(:user, :registered, :admin) }
    let!(:user)            { create(:user, :registered, :player) }
    let!(:user_2)          { create(:user, :registered, :player) }
    it 'when admin it should lead to a show page' do
      allow(helper).to receive(:current_user?).and_return false
      expect(helper.link_to_user(user, admin)).to include('a href')
    end

    it 'when current user visits its own details' \
       ' it should lead to th show page' do
      allow(helper).to receive(:current_user?).and_return true
      expect(helper.link_to_user(user, user)).to include('a href')
    end
    it 'when neither admin, nor current_user, ' \
       ' it should not link to show page' do
      allow(helper).to receive(:current_user?).and_return false
      expect(helper.link_to_user(user, user_2)).not_to include('a href')
      expect(helper.link_to_user(user, user_2)).to include(user.full_name)
    end
  end

  describe '#status_label' do
    let!(:setup)              { create(:user, :setup, :player) }
    let!(:invited)            { create(:user, :invited, :player) }
    let!(:googled)            { create(:user, :googled, :player) }
    let!(:archived)           { create(:user, :archived, :player) }
    let!(:registered)         { create(:user, :registered, :player) }
    # let!(:a_policy)           { double('policy_double') }

    # before do
    #   allow(subject).to receive(:policy).and_return a_policy
    #   allow(a_policy).to receive(:invite?).and_return true
    # end
    it 'shoud label invited with warning ' do
      expect(helper.status_label(invited)).to include('label-warning')
    end
    it 'shoud label googled status players with info ' do
      expect(helper.status_label(googled)).to include('label-info')
    end
    it 'shoud label archived players with default ' do
      expect(helper.status_label(archived)).to include('label-default')
    end
    it 'shoud label foreigners with danger '
    # do
      # - if policy(user).invite?
    #   expect(helper.status_label(setup)).to include('label-danger')
    # end
    it 'shoud label invited with warning ' do
      expect(helper.status_label(registered)).not_to include('label-')
    end
    it 'shoud invited foreigners to have an "invite" button'
    # do
    #   expect(status_label(setup)).to render_template(
    #     partial: 'show_invite_button',
    #     locals: { user: setup }
    #   )
    # end
  end

  describe '#event_date_link' do
    let(:a_string) { 'a string' }
    let(:course) { create(:course) }
    let(:performance) { create(:performance) }
    it 'should let a string go through' do
      expect(helper.event_date_link(a_string)).to eq(a_string)
    end
    it 'should return a link with a date when a course' do
      expect(helper.event_date_link(course)).to eq(
        link_to "Dans #{time_ago_in_words(course.event_date)}", courses_path
      )
    end
    it 'should return a link with a date when a performance' do
      expect(helper.event_date_link(performance)).to eq(
        link_to "Dans #{time_ago_in_words(course.event_date)}",
                performance_path(performance
        )
      )
    end
  end

  describe '#random_next_season_image' do
    context 'this is winter time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 12, 29) }
      end
      it 'it returns an image' do
        expect(helper.random_next_season_image.split('.').last).to eq('png')
      end
      it 'it returns a spring image' do
        expect(helper.random_next_season_image).to include('spring')
      end
    end
  end

  describe '#random_current_season_image' do
    context 'this is winter time !' do
      before do
        allow(Date).to receive(:today) { Date.new(2018, 12, 29) }
      end
      it 'it returns an image' do
        expect(helper.random_current_season_image.split('.').last).to eq('png')
      end
      it 'it returns a winter image' do
        expect(helper.random_current_season_image).to include('winter')
      end
    end
  end

  describe '#committee_tag_display' do
    let(:user) { build(:user) }
    subject { helper.committee_tag_display(user) }
    before do
      allow(user).to receive(:committee_list) { ['tag1', 'tag2'] }
    end
    it 'it should deliver 2 badges' do
      expect(subject).to include('label')
      expect(subject).to include('label-success')
      expect(subject).to include('img')
      expect(subject).to include('tag1')
      expect(subject).to include('tag2')
    end
  end
end
