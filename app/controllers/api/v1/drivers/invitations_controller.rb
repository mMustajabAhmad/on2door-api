class Api::V1::Drivers::InvitationsController < Devise::InvitationsController
  before_action :authenticate_administrator!, only: [:create]

  def devise_mapping
    action_name == 'create' ? Devise.mappings[:administrator] : Devise.mappings[:driver]
  end

  def create
    authorize! :create, Driver.new(organization_id: current_administrator.organization_id)

    return render json: { error: "At least one team must be assigned" }, status: :unprocessable_entity if params[:team_ids].blank?

    driver = Driver.invite!(
      {
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone_number: params[:phone_number],
        is_active: false,
        pending_team_ids: params[:team_ids]
      },
      current_administrator
    )

    render json: { driver: DriverSerializer.new(driver).as_json }, status: :ok
  end

  def update
    driver = Driver.accept_invitation!(
      params.permit(
      :invitation_token,
      :password,
      :password_confirmation
    ))

    driver.assign_pending_teams

    if driver.valid?
      render json: { driver: DriverSerializer.new(driver).as_json }, status: :ok
    else
      render json: { error: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
