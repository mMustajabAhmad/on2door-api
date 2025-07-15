class Api::V1::Administrators::RegistrationsController < Devise::RegistrationsController
  include CountryCodeHelper

  def create
    ActiveRecord::Base.transaction do
      country = signup_params[:organization_attributes][:country]
      return render json: { message: "Invalid country name: #{country}. Please use the official English country name or 2-letter code." }, status: :unprocessable_entity if (code = country_code(country)).nil?

      timezone = TZInfo::Country.get(code).zones.first&.identifier || 'UTC'
      organization_attrs = signup_params[:organization_attributes].merge(
        email: signup_params[:email],
        timezone: timezone
      )
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
      administrator_data = AdministratorSerializer.new(resource).as_json
      organization_data = OrganizationSerializer.new(resource.organization).as_json
      administrator_data[:organization] = organization_data

      render json: { auth_token: @token, data: administrator_data }, status: :ok
    end
end
