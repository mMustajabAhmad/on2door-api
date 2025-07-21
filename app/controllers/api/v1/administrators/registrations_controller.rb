class Api::V1::Administrators::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]
  skip_before_action :set_current_organization

  def create
    ActiveRecord::Base.transaction do
      organization_attrs = signup_params[:organization_attributes].merge(email: signup_params[:email])
      organization = Organization.create!(organization_attrs)

      build_resource(signup_params.except(:organization_attributes))
      resource.organization = organization
      resource.role = :owner
      resource.is_active = true
      resource.is_account_owner = true
      resource.save!

      if resource.persisted?
        sign_in(resource_name, resource)
        render_success_response(resource)
      else
        render json: { message: "Organization couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
      end
    end

  rescue ActiveRecord::RecordInvalid => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: permitted_signup_keys)
    end

    def signup_params
      params.require(:administrator).permit(permitted_signup_keys)
    end

    def permitted_signup_keys
      [
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
      ]
    end

    def render_success_response(resource)
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token
      administrator_data = ADMINISTRATOR_SERIALIZER.new(resource, params: {auth_token: @token}).as_json
      organization_data = ORGANIZATION_SERIALIZER.new(resource.organization).as_json
      administrator_data[:organization] = organization_data

      render json: { data: administrator_data }, status: :ok
    end
end
