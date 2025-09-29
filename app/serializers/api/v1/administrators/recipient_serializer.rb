class Api::V1::Administrators::RecipientSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :phone_number
end
