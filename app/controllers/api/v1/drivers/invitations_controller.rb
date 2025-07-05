class Api::V1::Drivers::InvitationsController < Devise::InvitationsController
  respond_to :json
  before_action :authenticate_administrator!, only: [:create]
  before_action :authenticate_driver!, only: [:update]

  def devise_mapping
    Devise.mappings[:administrator]
  end

  def create
    driver = Driver.invite!(
      {
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

    if driver.valid?
      render json: {
        driver: DriverSerializer.new(driver).as_json
      }, status: :ok
    else
      render json: {
        error: driver.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
