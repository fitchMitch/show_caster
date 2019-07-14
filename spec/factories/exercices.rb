# frozen_string_literal: true

FactoryBot.define do
  factory :exercice do
    title             { FFaker::Lorem.sentence(1).truncate(40) }
    instructions      { FFaker::Lorem.paragraph(3) }
    category          { Exercice.categories.keys.sample }
    focus             { FFaker::Lorem.paragraph(1)  }
    promess           { FFaker::Lorem.paragraph(1)  }
    energy_level      { Exercice.energy_levels.keys.sample }
    max_people        { Exercice.max_people.keys.sample }

    after(:create) do |exercice|
      skills = %w[body_language emotion being_true long_tag_expression]
      exercice.skill_list.add(skills.sample(2).join(', '), parse: true)
      exercice.save
    end
  end
end
