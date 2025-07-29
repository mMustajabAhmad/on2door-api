class ApplicationController < ActionController::API
  set_current_tenant_through_filter
  before_action :set_current_organization

  include Pagy::Backend
  include CanCan::ControllerAdditions

  ADMINISTRATOR_SERIALIZER = Api::V1::Administrators::AdministratorSerializer
  DRIVER_SERIALIZER = Api::V1::Drivers::DriverSerializer
  HUB_SERIALIZER = Api::V1::Administrators::HubSerializer
  ORGANIZATION_SERIALIZER = Api::V1::Administrators::OrganizationSerializer
  TEAM_SERIALIZER = Api::V1::Administrators::TeamSerializer
  TASK_SERIALIZER = Api::V1::Administrators::TaskSerializer

  def current_ability
    @current_ability ||= Ability.new(current_administrator || current_driver)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access denied: #{exception.message}" }, status: :forbidden
  end

  private
    def set_current_organization
      ActsAsTenant.current_tenant = current_administrator.organization if current_administrator
    end
end
