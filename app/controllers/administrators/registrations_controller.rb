class Administrators::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: {
          code: 200,
          message: 'Signed up successfully',
          token: @token,
          data: AdministratorSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: "Signup failed: #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end
end
