module Types
  class MutationType < Types::BaseObject
    field :create_jam, mutation: Mutations::CreateJam
    field :update_jam, mutation: Mutations::UpdateJam
  end
end
