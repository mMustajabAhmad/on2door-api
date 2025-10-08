class Api::V1::Administrators::SessionsController < Devise::SessionsController

  private
    def respond_with(resource, _opt = {})
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token
      render json: { administrator: ADMINISTRATOR_SERIALIZER.new(resource, params: {auth_token: @token}).as_json }, status: :ok
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last, ENV.fetch('DEVISE_JWT_SECRET_KEY')).first
        current_administrator = Administrator.find(jwt_payload['sub'])
      end

      if current_administrator
        render json: { message: 'Logged out successfully.' }, status: :ok
      else
        render json: { message: "Couldn't find an active session." }, status: :unauthorized
      end
    end
end
