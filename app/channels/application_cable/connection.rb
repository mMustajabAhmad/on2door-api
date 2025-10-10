class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user

  def connect
    self.current_user = find_verified_user
  end

  private
    def find_verified_user
      if token = request.params[:auth_token]
        begin
          decoded_token = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, {algorithm: 'HS256'})
          user_id = decoded_token[0]['sub']
          user_type = decoded_token[0]['scp']

          if user_type == 'driver'
            user = Driver.find_by(id: user_id)
          elsif user_type == 'administrator'
            user = Administrator.find_by(id: user_id)
          else
            user = nil
          end

          if user
            user
          else
            reject_unauthorized_connection
          end
        rescue JWT::DecodeError, JWT::ExpiredSignature
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end
end
