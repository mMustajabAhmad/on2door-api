class OrganizationSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :name, :country, :monthly_delivery_volume, :primary_industry, :message
end
