# == Schema Information
#
# Table name: events
#
#  id              :integer          not null primary key
#  event_date      :datetime
#  duration        :integer
#  progress        :integer          default(draft)
#  note            :text
#  user_id         :integer
#  theater_id      :integer
#  fk              :string
#  provider        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string
#  type            :string           default(Performance)
#  courseable_id   :integer
#  courseable_type :string
#

FactoryBot.define do
  factory :course do
    event_date      {Time.zone.now + 2.days}
    duration        {100}
    note            {'MyText'}
    title           {'Un bon petit cours de derrière les fagots'}
    theater
    # user{}
    provider        {'google'}
    fk              { 'a' * 40 }
    progress        {0}
    type            {'Course'}
    # courseable_type = %w[Coach User].sample
    # courseable_id = if courseable_type == 'User'
    #   User.all.sample.id
    # else
    #   Coach.all.sample.id
    # end
    factory :course_with_coach do
      after(:create) do |course|
        create(:coach, courseable: course)
      end
    end
  end
end
