class Api::V1::Administrators::AddressSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :street, :street_number, :city, :state, :country, :postal_code, :appartment, :latitude, :longitude, :addressable_type, :addressable_id
end
