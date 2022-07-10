module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def ready?(_args)
      return true if context[:current_v1_user]

      raise GraphQL::ExecutionError, "You don't have permission to do this"
    end
  end
end
