module Types
  class EntryType < Types::BaseObject
    description 'ジャムセッションへの申込'
    field :id, ID, 'ID', null: false
    field :jam_id, ID, 'ジャムセッションID', null: false
    field :user_id, ID, 'ユーザーID', null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, '作成日時', null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, '更新日時', null: false
  end
end
