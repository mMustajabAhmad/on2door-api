class Api::V1::Administrators::InvitationsController < Devise::InvitationsController
  before_action :authenticate_administrator!
  
  respond_to :json

  # POST /api/v1/invitations
  def create
    admin = Administrator.invite!({
      email: params[:email],
      first_name: params[:first_name],
      last_name: params[:last_name],
      phone_number: params[:phone_number],
      role: params[:role],
      is_read_only: params[:is_read_only],
      is_account_owner: false,
      is_active: false,
      organization_id: current_administrator.organization_id,
    },
      current_administrator
    )

    render json: {
      message: "Invitation sent",
      admin: admin
    }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # PUT /api/v1/invitation/accept
  def update
    admin = Administrator.accept_invitation!(
      params.permit(
        :invitation_token,
        :password,
        :password_confirmation
      )
    )

    if admin.errors.empty?
      render json: {
        message: "Invitation accepted",
        admin: admin
      }, status: :ok
    else
      render json: {
        error: admin.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
