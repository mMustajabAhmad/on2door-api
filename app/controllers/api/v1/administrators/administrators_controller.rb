class Api::V1::Administrators::AdministratorsController < ApplicationController
  load_and_authorize_resource

  def index
    @administrators = params[:administrator_type] == 'admin' ? @administrators.where(role: ['owner', 'admin']) :  @administrators.where(role: 'dispatcher')

    q = @administrators.ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { administrators: AdministratorSerializer.new(records).as_json, total_count: pagy.count }, status: :ok
  end

  def show
    render json: { administrator: AdministratorSerializer.new(@administrator).as_json }, status: :ok
  end

  def update
    if @administrator.update(administrator_params.except(:team_ids))
      @administrator.teams = Team.where(id: params[:administrator][:team_ids], organization_id: current_administrator.organization_id) if @administrator.role == 'dispatcher' && params[:administrator][:team_ids]
      render json: { administrator: AdministratorSerializer.new(@administrator).as_json }, status: :ok
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
