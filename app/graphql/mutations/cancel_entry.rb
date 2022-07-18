module Mutations
  class CancelEntry < Mutations::BaseMutation
    field :jam, Types::JamType
    argument :jam_id, ID, required: true

    def resolve(jam_id:)
      jam = Jam.find(jam_id)
      context[:current_v1_user].entries.find_by(jam:)&.destroy
    end
  end
end
