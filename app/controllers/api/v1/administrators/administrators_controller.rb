class Api::V1::Administrators::AdministratorsController < ApplicationController
  before_action :authenticate_administrator!
  load_and_authorize_resource

  def index
    @administrators = params[:administrator_type] == 'admin' ? @administrators.admins_and_owners :  @administrators.dispatcher

    q = @administrators.ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { administrators: ADMINISTRATOR_SERIALIZER.new(records).as_json, total_count: pagy.count }, status: :ok
  end

  def show
    render json: { administrator: ADMINISTRATOR_SERIALIZER.new(@administrator).as_json }, status: :ok
  end

  def update
    if @administrator.update(administrator_params)
      render json: { administrator: ADMINISTRATOR_SERIALIZER.new(@administrator).as_json }, status: :ok
    else
      render json: { error: @administrator.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @administrator.destroy
      render json: { message: 'Administrator deleted successfully' }, status: :ok
    else
      render json: { error: @administrator.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def administrator_params
      params.require(:administrator).permit(:email, :first_name, :last_name, :phone_number, team_ids: [])
    end
end
