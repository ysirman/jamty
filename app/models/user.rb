class User < ApplicationRecord
  # see https://github.com/waiting-for-dev/devise-jwt#jtimatcher
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :owned_jams, class_name: 'Jam', dependent: nil
  has_many :entries, dependent: :destroy
  has_many :entered_jams, through: :entries, source: :jam

  def jwt_payload
    super.merge(
      attributes.slice(
        'id',
        'name',
        'nickname',
        'image',
        'description',
        'location'
      )
    )
  end
end
