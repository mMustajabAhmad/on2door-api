class Api::V1::Administrators::TeamsController < ApplicationController
  before_action :authenticate_administrator!
  load_and_authorize_resource

  def index
    q = @teams.ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { teams: TEAM_SERIALIZER.new(records).as_json, total_count: pagy.count}, status: :ok
  end

  def show
    render json: { team: TEAM_SERIALIZER.new(@team).as_json }, status: :ok
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      render json: { team: TEAM_SERIALIZER.new(@team).as_json }, status: :ok
    else
      render json: { error: @team.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    return render json: { error: 'Team must have atleast one driver' }, status: :unprocessable_entity if team_params[:driver_ids]&.blank?

    if @team.update(team_params)
      render json: { team: TEAM_SERIALIZER.new(@team).as_json }, status: :ok
    else
      render json: { error: @team.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @team.destroy
      render json: { message: 'Team deleted successfully' }, status: :ok
    else
      render json: { error: team.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def team_params
      params.require(:team).permit(:name, :hub_id, administrator_ids: [], driver_ids: [])
    end
end
