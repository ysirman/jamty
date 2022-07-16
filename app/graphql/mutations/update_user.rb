module Mutations
  class UpdateUser < Mutations::BaseMutation
    field :user, Types::UserType, null: false
    argument :params, Types::Inputs::UserInputType, required: true

    def resolve(params:)
      context[:current_v1_user].update!(params.to_h.compact)
      { user: context[:current_v1_user] }
    end
  end
end
