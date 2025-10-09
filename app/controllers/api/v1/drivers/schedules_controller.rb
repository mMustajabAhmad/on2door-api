class Api::V1::Drivers::SchedulesController < ApplicationController
  before_action :authenticate_driver!
  load_and_authorize_resource

  def index
    q = @schedules.includes(:subschedules).ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { schedules: SCHEDULE_SERIALIZER.new(records).as_json, total_count: pagy.count }, status: :ok
  end

  def show
    render json: { schedule: SCHEDULE_SERIALIZER.new(@schedule).as_json }, status: :ok
  end

  def create
    @schedule = current_driver.schedules.build(schedule_params)

    if @schedule.save
      render json: { schedule: SCHEDULE_SERIALIZER.new(@schedule).as_json }, status: :ok
    else
      render json: { error: @schedule.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    if @schedule.update(schedule_params)
      render json: { schedule: SCHEDULE_SERIALIZER.new(@schedule).as_json }, status: :ok
    else
      render json: { error: @schedule.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @schedule.destroy
      render json: { message: 'Schedule deleted successfully' }, status: :ok
    else
      render json: { error: @schedule.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def schedule_params
      params.require(:schedule).permit(:date)
    end
end
