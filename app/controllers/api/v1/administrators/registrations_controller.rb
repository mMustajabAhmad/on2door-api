class Api::V1::Administrators::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private
  def respond_with(resource, opt={})
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token
      render json: {
        status: { 
          code: 200, 
          message: 'Signed up successfully.',
          auth_token: @token,
          data: AdministratorSerializer.new(resource).serializable_hash[:data][:attributes] }
      }, status: :ok
    else
      render json: {
        status: {
          message: "Administrator couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end
end
