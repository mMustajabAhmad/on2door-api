class HubSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :organization_id, :team_ids

  attribute :address do |hub|
    hub.address&.slice(:id, :street, :city, :state, :postal_code, :country)
  end
end
