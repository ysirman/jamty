module Queries
  class UserQuery < Queries::BaseQuery
    description 'ユーザー詳細取得'
    type Types::UserType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      User.find(id)
    end
  end
end
