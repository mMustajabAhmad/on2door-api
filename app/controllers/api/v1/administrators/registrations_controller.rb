class Api::V1::Administrators::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_signup_params, only: [:create]

  def create
    ActiveRecord::Base.transaction do
      organization_attrs = signup_params[:organization_attributes].merge(email: signup_params[:email])
      organization = Organization.create!(organization_attrs)

      build_resource(sign_up_params.except(:organization_attributes))
      resource.organization = organization
      resource.role = :owner
      resource.is_active = true
      resource.is_account_owner = true
      resource.save!

      if resource.persisted?
        sign_in(resource_name, resource)
        render_success_response(resource)
      else
        render_error_response(resource)
      end
    end

  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: e.message
    }, status: :unprocessable_entity
  end

  private

    def configure_signup_params
      devise_parameter_sanitizer.permit(:sign_up, keys:[
        :first_name,
        :last_name,
        :phone_number,
        :email,
        :password,
        organization_attributes: [
          :name,
          :country,
          :monthly_delivery_volume,
          :primary_industry,
          :message
        ]
      ])
    end

    def signup_params
      params.require(:administrator).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :phone_number,
        organization_attributes: [
          :name,
          :country,
          :monthly_delivery_volume,
          :primary_industry,
          :message
        ]
      )
    end

    def render_success_response(resource)
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token
      administrator_data = AdministratorSerializer.new(resource).as_json
      organization_data = OrganizationSerializer.new(resource.organization).as_json
      administrator_data[:organization] = organization_data

      render json: {
        auth_token: @token,
        data: administrator_data
      }, status: :ok
    end

    def render_errror_response(resource)
      render json: {
        message: "Organization couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
end
