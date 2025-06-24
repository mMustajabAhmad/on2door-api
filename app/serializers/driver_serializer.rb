class DriverSerializer
  include JSONAPI::Serializer
  attributes :id, :email
end
