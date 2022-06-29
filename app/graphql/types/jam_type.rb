module Types
  class JamType < Types::BaseObject
    description "ジャムセッションイベント"
    field :id, ID, null: false
    field :scheduled_for, GraphQL::Types::ISO8601DateTime
    field :prefecture_id, Integer
    field :place, String
    field :description, String
    field :canceled_at, GraphQL::Types::ISO8601DateTime

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
