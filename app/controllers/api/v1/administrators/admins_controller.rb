class Api::V1::Administrators::AdminsController < ApplicationController
  before_action :authenticate_administrator_role, only: [:show, :update, :destroy]

  def index
    administrator_type = params[:administrator_type]
    administrators =
    if administrator_type == 'admin'
      if current_administrator.role.in?(['owner', 'admin'])
        current_administrator.organization.administrators.where(role: ['owner', 'admin'])
      else
        Administrator.none
      end
    elsif administrator_type == 'dispatcher'
      if current_administrator.role.in?(['owner', 'admin'])
        current_administrator.organization.administrators.dispatcher
      elsif current_administrator.role == 'dispatcher'
        Administrator.dispatcher.joins(:teams).where(teams: {id: current_administrator.team_ids}).distinct
      else
        Administrator.none
      end
    else
      Administrator.none
    end

    q = administrators.ransack(params[:q])
    pagy, administrators = pagy(q.result, page: params[:page],limit: params[:per_page])

    render json: {
      administrators: AdministratorSerializer.new(administrators).as_json,
      pagy: pagy
    }, status: :ok
  end

  def show
    administrator = current_administrator.organization.administrators.find(params[:id])
    render json: {
      administrator: AdministratorSerializer.new(administrator).as_json
    }

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Administrator not found'
    }, status: :not_found
  end

  def update
    administrator = current_administrator.organization.administrators.find(params[:id])
    if current_administrator.role.in?(['admin', 'dispatcher'])
      if administrator.role == 'owner'
        render json: {
          error: "Owner can't be updated"
        }, status: :unprocessable_entity
        return
      end
    end

    if administrator.update(administrator_params.except(:team_ids))
      if administrator.role == 'dispatcher' && params[:administrator][:team_ids].present?
        team_ids = Array(params[:administrator][:team_ids]).map(&:to_i)
        teams = Team.where(id: team_ids, organization_id: current_administrator.organization_id)
        administrator.teams = teams
        administrator.save
      elsif administrator.role == 'dispatcher' && params[:administrator].key?(:team_ids)
        administrator.teams = []
        administrator.save
      end

      render json: {
        administrator: AdministratorSerializer.new(administrator).as_json
      }
    else
      render json: {
        error: administrator.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Administrator not found'
    }, status: :not_found
  end

  def destroy
    admin = current_administrator.organization.administrators.find(params[:id])

    if admin.role == 'owner'
      render json: {
        error: "Owner can't be deleted"
      }, status: :unprocessable_entity
      return
    end

    if admin.id == current_administrator.id
      render json: {
        error: "You can't delete your own account"
      }, status: :unprocessable_entity
      return
    end

    if admin.destroy
      render json: {
        message: 'Administrator deleted successfully'
      }, status: :ok
    else
      render json: {
        error: admin.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: 'Administrator not found'
    }, status: :not_found
  end

  private
    def administrator_params
      params.require(:administrator).permit(:email, :first_name, :last_name, :phone_number, team_ids: [])
    end

    def authenticate_administrator_role
      unless current_administrator.role.in?(['owner', 'admin'])
        render json:{
          error: 'Forbidden access'
        }, status: :unprocessable_entity
      end
    end
end
