class Api::V1::Administrators::HubsController < ApplicationController
  before_action :authenticate_administrator!
  load_and_authorize_resource

  def index
    q = @hubs.includes(:address).ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page],limit: params[:per_page])

    render json: { hubs: HubSerializer.new(records).as_json, total_count: pagy.count}, status: :ok
  end

  def show
    render json: HubSerializer.new(@hub).as_json, status: :ok
  end

  def create
    @hub = Hub.new(hub_params.merge(organization_id: current_administrator.organization_id))

    if @hub.save
      render json: HubSerializer.new(@hub).as_json, status: :ok
    else
      render json: { error: @hub.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    if @hub.update(hub_params)
      render json: HubSerializer.new(@hub).as_json, status: :ok
    else
      render json: { error: @hub.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @hub.destroy
      render json: { message: "Hub deleted successfully." }, status: :ok
    else
      render json: { error: @hub.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def hub_params
      params.require(:hub).permit(
        :name,
        team_ids: [],
        address_attributes: [:street, :city, :state, :postal_code, :country]
      )
    end
end
