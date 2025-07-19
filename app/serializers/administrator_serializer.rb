class AdministratorSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name, :phone_number, :role, :organization_id, :pending_team_ids, :team_ids, :is_active, :is_account_owner, :is_read_only, :invited_by_id, :invited_by_type, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at

  attribute :invited_by_role, if: Proc.new { |administrator| administrator.invited_by_id.present? } do |administrator|
    Administrator.find_by(id: administrator.invited_by_id)&.role
  end

  attribute :auth_token, Proc.new { |admin, params| params[:auth_token] }
end
