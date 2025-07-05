class DriverSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name, :is_active, :organization_id,  :invited_by_id, :invited_by_type, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at

  attribute :invited_by_role do |object|
    if object.invited_by_id.present?
      inviter = Administrator.find_by(id: object.invited_by_id)
      inviter&.role
    end
  end
end
