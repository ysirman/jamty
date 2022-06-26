class User < ApplicationRecord
  # see https://github.com/waiting-for-dev/devise-jwt#jtimatcher
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

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
