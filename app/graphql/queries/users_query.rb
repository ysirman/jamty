module Queries
  class UsersQuery < Queries::BaseQuery
    description 'ユーザー一覧取得'
    type [Types::UserType], null: false

    def resolve
      User.limit(20)
    end
  end
end
