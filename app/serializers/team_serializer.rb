class TeamSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :enable_self_assign, :organization_id, :hub_id

  attribute :administrator_ids do |object|
    object.administrator_ids
  end
end
