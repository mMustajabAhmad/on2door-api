class Api::V1::Drivers::SessionsController < Devise::SessionsController

  private
    def respond_with(resource, _opt = {})
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token
      render json: { driver: DriverSerializer.new(resource, params: {auth_token: @token}).as_json }, status: :ok
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                Rails.application.credentials.devise_jwt_secret_key!).first
        current_driver = Driver.find(jwt_payload['sub'])
      end

      if current_driver
        render json: { message: 'Logged out successfully.' }, status: :ok
      else
        render json: { message: "Couldn't find an active session." }, status: :unauthorized
      end
    end
end
