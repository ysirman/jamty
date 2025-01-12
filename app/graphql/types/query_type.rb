module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :jam, resolver: Queries::JamQuery
    field :jams, resolver: Queries::JamsQuery
    field :jams_connection, resolver: Queries::JamsConnection
    field :user, resolver: Queries::UserQuery
    field :users, resolver: Queries::UsersQuery
  end
end
