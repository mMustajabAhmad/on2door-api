class Api::V1::Drivers::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        @token = request.env['warden-jwt_auth.token']
        headers['Authorization'] = @token
        render json: {
          token: @token,
          driver: DriverSerializer.new(resource).as_json
        }, stauts: :ok
      else
        render json: {
          message: "Driver couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }, status: :unprocessable_entity
      end
    end
end
