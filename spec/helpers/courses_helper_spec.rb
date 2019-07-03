require 'rails_helper'

RSpec.describe CoursesHelper, type: :helper do
  describe '#coach_name' do
    let(:course_with_coach) { build(:course_with_coach) }
    let(:course) { build(:auto_coached_course) }
    it 'shall give a correct name to a coach' do
      expect(helper.coach_name(course_with_coach)).to include(course_with_coach
                                                              .courseable
                                                              .full_name)
      expect(helper.coach_name(course_with_coach)).to include('fa-star')
    end
    it 'shall give a correct name to a member coaching' do
      expect(helper.coach_name(course)).to include(course
                                                  .courseable
                                                  .full_name)
    end
  end

  describe '#course_label' do
    context 'when courses list is not empty' do
      let(:course_with_coach) { build(:course_with_coach) }
      let(:course) { build(:auto_coached_course) }
      it 'should label "Coach" courses from a coach' do
        expect(helper.course_label(course_with_coach)).to include('Coach')
      end
      it 'should label course with "auto coaché" when autocoached' do
        expect( helper.course_label(course)).to include('Auto coaché')
      end
      it 'should label with a member name' do
        expect(helper.course_label(course)).to include(course.courseable.full_name)
      end
    end

    context 'when course list is empty' do
      let(:wording) { 'pas de cours prévu' }
      it { expect(helper.course_label(wording)).to eq(wording)  }
    end
  end
end
