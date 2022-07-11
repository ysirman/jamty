module Types
  class JamType < Types::BaseObject
    description 'ジャムセッションイベント'
    field :canceled_at, GraphQL::Types::ISO8601DateTime, 'キャンセル日時'
    field :description, String, '詳細説明'
    field :id, ID, 'ID', null: false
    field :place, String, '開催場所'
    field :prefecture_id, Integer, '都道府県ID'
    field :scheduled_for, GraphQL::Types::ISO8601DateTime, '予定日時'
    field :user_id, ID, 'ID', null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, '作成日時', null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, '更新日時', null: false
  end
end
