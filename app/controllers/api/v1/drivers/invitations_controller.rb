class Api::V1::Drivers::InvitationsController < Devise::InvitationsController
  before_action :authenticate_administrator!, only: [:create]
  before_action :authenticate_driver!, only: [:update]
  respond_to :json

  def devise_mapping
    Devise.mappings[:administrator]
  end

  def create
    driver = Driver.invite!({
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone_number: params[:phone_number],
        is_active: false,
        organization_id: current_administrator.organization_id
      },
      current_administrator
    )
    render json: {
      message: "Invitation sent",
      driver: DriverSerializer.new(driver).as_json
    }, status: :ok
  rescue => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  def update
    driver = Driver.accept_invitation!(
      params.permit(
      :invitation_token,
      :password,
      :password_confirmation
    ))
    if driver.errors.empty?
      render json: {
        message: "Invitation accepted", 
        driver: DriverSerializer.new(driver).as_json
      }, status: :ok
    else
      render json: {
        error: driver.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
