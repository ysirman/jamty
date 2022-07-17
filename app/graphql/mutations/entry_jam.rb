module Mutations
  class EntryJam < Mutations::BaseMutation
    field :jam, Types::JamType
    argument :jam_id, ID, required: true

    def resolve(jam_id:)
      jam = Jam.find(jam_id)
      context[:current_v1_user].entry!(jam)
    end
  end
end
