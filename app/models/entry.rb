class Entry < ApplicationRecord
  belongs_to :jam
  belongs_to :candidate, class_name: 'User', foreign_key: :user_id, inverse_of: :entries

  validates :jam_id, uniqueness: { scope: :user_id }
end
