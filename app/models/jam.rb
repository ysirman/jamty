class Jam < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id, inverse_of: :owned_jams
  has_many :entries, dependent: :destroy
  has_many :candidates, through: :entries, dependent: :destroy

  scope :canceled, -> { where.not(canceled_at: nil) }
end
