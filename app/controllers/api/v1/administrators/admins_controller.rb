class Api::V1::Administrators::AdminsController < ApplicationController

  def index
    administrator_type = params[:administrator_type]
    adminis = 
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
      Administrators.none
    end

    render json: {
      admins: AdministratorSerializer.new(adminis).as_json
    }
  end
end
