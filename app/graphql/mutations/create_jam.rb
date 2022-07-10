module Mutations
  class CreateJam < Mutations::BaseMutation
    field :jam, Types::JamType, null: false
    argument :params, Types::Inputs::JamInputType, required: true

    def resolve(params:)
      jam = context[:current_v1_user].owned_jams.create!(params.to_h)
      { jam: }
    end
  end
end
