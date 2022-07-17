module Types
  class MutationType < Types::BaseObject
    field :cancel_jam, mutation: Mutations::CancelJam
    field :create_jam, mutation: Mutations::CreateJam
    field :entry_jam, mutation: Mutations::EntryJam
    field :uncancel_jam, mutation: Mutations::UncancelJam
    field :update_jam, mutation: Mutations::UpdateJam
    field :update_user, mutation: Mutations::UpdateUser
  end
end
