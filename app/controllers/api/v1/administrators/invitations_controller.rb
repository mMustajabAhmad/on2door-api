class Api::V1::Administrators::InvitationsController < Devise::InvitationsController

  def create
    authorize! :create, Administrator.new(role: params[:role])

    return render json: { error: 'Phone number has already been taken within organization' }, status: :unprocessable_entity if Administrator.exists?(phone_number: params[:phone_number], organization_id: current_administrator.organization_id)

    administrator = Administrator.invite!(
      {
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone_number: params[:phone_number],
        role: params[:role],
        is_read_only: params[:role] == 'dispatcher' ? params[:is_read_only] : false,
        is_account_owner: false,
        is_active: false,
        organization_id: current_administrator.organization_id,
        pending_team_ids: params[:role] == 'dispatcher' ? params[:team_ids] : nil
      },
      current_administrator
    )

    render json: { administrator: AdministratorSerializer.new(administrator).as_json }, status: :ok
  end

  def update
    administrator = Administrator.accept_invitation!(
      params.permit(
      :invitation_token,
      :password,
      :password_confirmation
    ))

    if administrator.role == 'dispatcher' && administrator.pending_team_ids?
      administrator.teams = Team.where(id: administrator.pending_team_ids, organization_id: administrator.organization_id)
      administrator.update(pending_team_ids: nil)
    end

    if administrator.valid?
      render json: { administrator: AdministratorSerializer.new(administrator).as_json }, status: :ok
    else
      render json: { error: administrator.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
