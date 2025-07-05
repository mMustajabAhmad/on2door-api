class Api::V1::Administrators::AdminsController < ApplicationController

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

    pagy, administrators = pagy(administrators, page: (params[:page]), items: (params[:per_page]))

    render json: {
      admins: AdministratorSerializer.new(administrators).as_json,
      pagy: pagy
    }, status: :ok
  end
end
