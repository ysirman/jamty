module Mutations
  class CancelJam < Mutations::BaseMutation
    field :jam, Types::JamType
    argument :id, ID, required: true

    def resolve(id:)
      jam = context[:current_v1_user].owned_jams
                                     .canceled
                                     .invert_where
                                     .find_by(id:)
      jam&.touch(:canceled_at) # rubocop:disable Rails/SkipsModelValidations
      { jam: }
    end
  end
end
