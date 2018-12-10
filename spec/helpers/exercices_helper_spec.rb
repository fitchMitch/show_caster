require 'rails_helper'
# require 'pundit'

RSpec.describe ExercicesHelper, type: :helper do
  # let!(:admin)           { create(:user, :registered, :admin) }
  describe '#skill_tag_display' do
    let!(:exercice) { create(:exercice) }
    it 'shall display tags with labels' do
      expect(
        helper.skill_tag_display(exercice)
      ).to include(
        "<span class=\"label label-success\">#{exercice.skills.first.name}</span>"
      )
      expect(
        helper.skill_tag_display(exercice)
      ).to include(
        "<span class=\"label label-success\">#{exercice.skills.second.name}</span>"
      )
      expect(
        helper.skill_tag_display(exercice)
      ).to include(
        "/assets/transp"
      )
    end
  end
end
