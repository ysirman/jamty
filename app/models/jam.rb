class Jam < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id, inverse_of: :owned_jams
end
