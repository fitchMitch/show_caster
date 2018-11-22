class Committee < ApplicationRecord
  # Relationships
  has_many :users
  # Validations
  validates :name,
            presence: true,
            length: { minimum: 3, maximum: 45 }

  def self.allow_to_destroy?
    Committee.all.count > 1
  end

  def self.select_list
    Committee.select(:name, :id)
  end

  def redispatch_users
    default_committee = Committee.where.not(id: id).first
    User.where('committee_id = ? OR committee_id is null', id).each do |user|
      user.update_column(:committee_id, default_committee.id)
    end
  end
end
