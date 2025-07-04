class Api::V1::Administrators::InvitationsController < Devise::InvitationsController
  respond_to :json
  before_action :authenticate_administrator!

  def create
    if params[:role] == 'owner'
      render json: { 
        error: "You cannot invite an owner."
      }, status: :unprocessable_entity
      return
    end
    
    admin = Administrator.invite!(
      {
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone_number: params[:phone_number],
        role: params[:role],
        is_read_only: params[:is_read_only],
        is_account_owner: false,
        is_active: false,
        organization_id: current_administrator.organization_id
      },
      current_administrator
    )

    render json: {
      administrator: AdministratorSerializer.new(admin).as_json
    }, status: :ok

  rescue => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  def update
    admin = Administrator.accept_invitation!(
      params.permit(
      :invitation_token,
      :password,
      :password_confirmation
    ))

    if admin.valid?
      render json: {
        administrator: AdministratorSerializer.new(admin).as_json
      }, status: :ok
    else
      render json: {
        error: admin.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
