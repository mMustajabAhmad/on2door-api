class ApplicationController < ActionController::API
  include Pagy::Backend
  include CanCan::ControllerAdditions

  def current_ability
    @current_ability ||= Ability.new(current_administrator || current_driver)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access denied: #{exception.message}" }, status: :forbidden
  end
end
