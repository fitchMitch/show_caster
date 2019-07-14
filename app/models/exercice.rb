# frozen_string_literal: true

class Exercice < ApplicationRecord
  acts_as_taggable
  acts_as_taggable_on :skills

  enum category: {
    space_sizing: 0,
    connexion: 1,
    time_sizing: 2,
    body_expression: 3,
    imagination: 4,
    story_telling: 5,
    just_listening: 6,
    confidence: 7
  }
  enum energy_level: {
    low: 0,
    standard: 1,
    high: 2
  }
  enum max_people: {
    everyone: 0,
    one: 1,
    two: 2,
    four: 4,
    six: 6
  }

  # Validations
  validates :title,
            presence: true,
            length: {
              minimum: 2,
              maximum: 40
            }
  validates :instructions,
            presence: true,
            length: {
              minimum: 5
            }

  def self.skill_names_list
    Exercice.skill_counts.pluck(:name)
  end
end
