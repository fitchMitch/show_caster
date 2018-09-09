require 'rails_helper'

RSpec.describe CoursesHelper, type: :helper do
  describe '#coach_name' do
    let(:course_with_coach) { build(:course_with_coach) }
    let(:course) { build(:course) }
    it 'shall give a correct name to a coach' do
      expect(helper.coach_name(course_with_coach)).to include(course_with_coach
                                                              .courseable
                                                              .full_name)
      expect(helper.coach_name(course_with_coach)).to include('fa-star')
    end
    it 'shall give a correct name to a member coaching' do
      expect(helper.coach_name(course)).to include(course
                                                  .user
                                                  .full_name)
    end
  end

  describe '#course_label' do
    let(:course_with_coach) { build(:course_with_coach) }
    let(:course) { build(:course) }
    it 'should give a proper label to courses from a coach' do
      expect(helper.course_label(course_with_coach)).to include('Coach')
    end
    it 'should give a proper label to courses from a member' do
      expect(helper.course_label(course)).to include('Auto coaché')
    end
  end
end
