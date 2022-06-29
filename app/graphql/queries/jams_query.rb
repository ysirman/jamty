module Queries
  class JamsQuery < Queries::BaseQuery
    type [Types::JamType], null: false

    def resolve
      Jam.limit(20)
    end
  end
end
