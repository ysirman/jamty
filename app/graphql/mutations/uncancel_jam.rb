module Mutations
  class UncancelJam < Mutations::BaseMutation
    field :jam, Types::JamType
    argument :id, ID, required: true

    def resolve(id:)
      jam = context[:current_v1_user].owned_jams
                                     .canceled
                                     .find_by(id:)
      jam&.update!(canceled_at: nil)
      { jam: }
    end
  end
end
