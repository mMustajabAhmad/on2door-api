class Api::V1::Administrators::OrganizationsController < ApplicationController
  before_action :authenticate_administrator!
  load_and_authorize_resource

  def index
    @organization = current_administrator.organization
    render json: { organization: OrganizationSerializer.new(@organization).as_json }, status: :ok
  end

  def update
    if @organization.update(organization_params)
      render json: { organization: OrganizationSerializer.new(@organization).as_json }, status: :ok
    else
      render json: { error: @organization.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def organization_params
      params.require(:organization).permit(:name, :email, :country)
    end
end
