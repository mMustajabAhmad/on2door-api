class Api::V1::Drivers::DriverSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name, :phone_number, :is_active, :organization_id, :pending_team_ids, :team_ids, :invited_by_id, :invited_by_type, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at

  attribute :invited_by_role, if: Proc.new { |driver| driver.invited_by_id.present? } do |driver|
    Administrator.find_by(id: driver.invited_by_id)&.role
  end

  attribute :auth_token, Proc.new { |driver, params| params[:auth_token] }

  attribute :vehicle_info do |driver|
    driver.vehicle && {
    id: driver.vehicle.id,
    license_plate: driver.vehicle.license_plate,
    type: driver.vehicle.vehicle_type,
    color: driver.vehicle.color,
    description: driver.vehicle.description
  }
  end
end
