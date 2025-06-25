class Drivers::RegistrationsController < Devise::RegistrationsController
   respond_to :json

  private
  def respond_with(resource, )
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: { 
          code: 200, 
          message: 'Signed up successfully.',
          auth_token: @token,
          data: DriverSerializer.new(resource).serializable_hash[:data][:attributes] }
      }, stauts: :ok
    else
      render json: {
        status: { 
          message: "Driver couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" 
        }
      }, status: :unprocessable_entity
    end
  end
end
