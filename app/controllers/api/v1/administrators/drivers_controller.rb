class Api::V1::Administrators::DriversController < ApplicationController
  load_and_authorize_resource

  def index
    q = @drivers.includes(:vehicle).ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page],limit: params[:per_page])

    render json: { drivers: DRIVER_SERIALIZER.new(records).as_json, total_count: pagy.count}, status: :ok
  end

  def show
    render json: { driver: DRIVER_SERIALIZER.new(@driver).as_json }, status: :ok
  end

  def update
    return render json: { error: 'Driver must be assigned to at least one team'}, status: :unprocessable_entity if driver_params[:team_ids].blank?

    if @driver.update(driver_params)
      render json: { driver: DRIVER_SERIALIZER.new(@driver).as_json }, status: :ok
    else
      render json: { error: driver.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @driver.destroy
      render json: { message: 'Driver deleted successfully' }, status: :ok
    else
      render json: { error: driver.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def driver_params
      params.require(:driver).permit(:email, :first_name, :last_name, :phone_number, team_ids: [])
    end
end
