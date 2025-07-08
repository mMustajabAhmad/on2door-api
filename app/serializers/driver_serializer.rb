class DriverSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name, :is_active, :organization_id,  :invited_by_id, :invited_by_type, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at

  attribute :invited_by_role, if: Proc.new { |driver| driver.invited_by_id.present? } do |driver|
    Administrator.find_by(id: driver.invited_by_id)&.role
  end
end
