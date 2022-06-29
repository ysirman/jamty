module Queries
  class JamQuery < Queries::BaseQuery
    type Types::JamType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Jam.find(id)
    end
  end
end
