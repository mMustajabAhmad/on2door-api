class TeamSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :organization_id, :hub_id

  attribute :dispatcher_ids do |object|
    object.administrators.dispatcher.ids
  end

  attribute :dispatchers_count do |object|
    object.administrators.dispatcher.count
  end
end
