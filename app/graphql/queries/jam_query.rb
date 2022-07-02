module Queries
  class JamQuery < Queries::BaseQuery
    description 'ジャムセッション詳細取得'
    type Types::JamType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Jam.find(id)
    end
  end
end
