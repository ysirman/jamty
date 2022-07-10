module Types
  class UserType < Types::BaseObject
    description 'ユーザー'
    field :description, String, '自己紹介'
    field :id, ID, 'ID', null: false
    field :image, String, 'Twitterのプロフィール画像'
    field :location, String, '活動場所'
    field :name, String, 'Twitterの@付きの名前', null: false
    field :nickname, String, 'Twitterの@付いてない方の名前', null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, '作成日時', null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, '更新日時', null: false
  end
end
