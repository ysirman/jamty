module Types
  module Inputs
    class JamInputType < Types::BaseInputObject
      description 'ジャムセッション作成の型'
      argument :description, String, required: false
      argument :place, String, required: false
      argument :prefecture_id, Integer, required: true
      argument :scheduled_for, GraphQL::Types::ISO8601Date, required: false
    end
  end
end
