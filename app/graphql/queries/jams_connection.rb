module Queries
  class JamsConnection < Queries::BaseQuery
    description 'ジャムセッション一覧ページネーション付き'
    type Types::JamType.connection_type, null: false

    def resolve
      Jam.all
    end
  end
end
