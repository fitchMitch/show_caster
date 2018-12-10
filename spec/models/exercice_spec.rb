require 'rails_helper'

RSpec.describe Exercice, type: :model do
  context 'with valid attributes' do
    let(:exercice_attributes) { attributes_for(:exercice)}
    let(:valid_attributes) do
    end

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(2) }
    it { should validate_length_of(:title).is_at_most(40) }

    it { should validate_presence_of(:instructions) }
    it { should validate_length_of(:instructions).is_at_least(5) }

    describe 'Persistance' do
      it 'should be verified : factory validation' do
        exercice = create(:exercice, exercice_attributes)

        expect(exercice.title).to eq(exercice_attributes[:title])
        expect(exercice.instructions).to eq(exercice_attributes[:instructions])
        expect(exercice.focus).to eq(exercice_attributes[:focus])
        expect(exercice.promess).to eq(exercice_attributes[:promess])
        expect(exercice.max_people).to eq(exercice_attributes[:max_people])
        expect(exercice.category).to eq(exercice_attributes[:category])
        expect(exercice.energy_level).to eq(exercice_attributes[:energy_level])
      end
    end
  end
end
