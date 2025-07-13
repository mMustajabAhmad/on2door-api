class Api::V1::Administrators::TeamsController < ApplicationController
  before_action :authenticate_administrator_role, only: [:show, :create, :update, :destroy]

  def index
    if current_administrator.role.in?(['owner', 'admin'])
      teams = current_administrator.organization.teams
    elsif current_administrator.role == 'dispatcher'
      teams = current_administrator.teams
    else
      teams = Team.none
    end

    q = teams.ransack(params[:q])
    pagy, teams = pagy(q.result, page: params[:page],limit: params[:per_page])

    render json: {
      teams: TeamSerializer.new(teams).serializable_hash,
      pagy: pagy
    }, status: :ok
  end

  def show
    team = current_administrator.organization.teams.find(params[:id])

    render json: {
      team: TeamSerializer.new(team).as_json
    }, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Team not found'
    }, status: :not_found
  end

  def create
    team = Team.new(team_params.except(:dispatcher_ids))
    team.organization_id = current_administrator.organization_id

    if team.save
      if team_params[:dispatcher_ids].present?
        dispatchers = Administrator.where(
          id: team_params[:dispatcher_ids],
          role: 'dispatcher',
          organization_id: current_administrator.organization_id
        )
        team.administrators << dispatchers
      end

      render json: {
        team: TeamSerializer.new(team).as_json
      }, status: :ok

    else
      render json: {
        error: team.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end

  rescue => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  def update
    team = current_administrator.organization.teams.find(params[:id])
    
    if team.update(team_params.except(:dispatcher_ids))
      if team_params.key?(:dispatcher_ids)
        dispatchers = Administrator.where(
          id: team_params[:dispatcher_ids],
          role: 'dispatcher',
          organization_id: current_administrator.organization_id
        )
        team.administrators = dispatchers
      end

      render json: {
        team: TeamSerializer.new(team).as_json
      }, status: :ok
    else
      render json: {
        error: team.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Team not found'
    }, status: :not_found
  end

  def destroy
    team = current_administrator.organization.teams.find(params[:id])
    if team.destroy
      render json: {
        message: 'Team deleted successfully'
      }, status: :ok
    else
      render json: {
        error: team.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Team not found'
    }, status: :not_found
  end

  private
    def team_params
      params.require(:team).permit(:name, :enable_self_assign, :hub_id, dispatcher_ids: [])
    end

    def authenticate_administrator_role
      unless current_administrator.role.in?(['owner', 'admin'])
        render json: {
          error: 'Forbidden Access'
        }, status: :unprocessable_entity
      end
    end
end
