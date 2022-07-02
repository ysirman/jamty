module Queries
  class JamsQuery < Queries::BaseQuery
    description 'ジャムセッション一覧取得'
    type [Types::JamType], null: false

    def resolve
      Jam.limit(20)
    end
  end
end
