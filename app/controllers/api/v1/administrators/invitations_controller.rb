class Api::V1::Administrators::InvitationsController < Devise::InvitationsController
  before_action :authenticate_administrator!, only: [:create]

  def create
    authorize! :create, Administrator.new(role: params[:role])

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

    administrator.assign_pending_teams

    if administrator.valid?
      render json: { administrator: AdministratorSerializer.new(administrator).as_json }, status: :ok
    else
      render json: { error: administrator.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
