module Types
  module Inputs
    class UserInputType < Types::BaseInputObject
      description 'ユーザー作成の型'
      argument :description, String, required: false
      argument :location, String, required: false
      argument :nickname, String, required: false
    end
  end
end
