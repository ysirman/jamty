module Mutations
  class UpdateJam < Mutations::BaseMutation
    field :jam, Types::JamType, null: false
    argument :id, ID, required: false
    argument :params, Types::Inputs::JamInputType, required: true

    def resolve(id:, params:)
      jam = context[:current_v1_user].owned_jams.find(id)
      jam.update!(params.to_h.compact)
      { jam: }
    end
  end
end
