class Api::V1::Drivers::SubschedulesController < ApplicationController
  before_action :authenticate_driver!
  load_and_authorize_resource

  def index
    q = @subschedules.includes(:schedule).ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { subschedules: SUBSCHEDULE_SERIALIZER.new(records).as_json, total_count: pagy.count }, status: :ok
  end

  def show
    render json: { subschedule: SUBSCHEDULE_SERIALIZER.new(@subschedule).as_json }, status: :ok
  end

  def create
    schedule = current_driver.schedules.find(subschedule_params[:schedule_id])
    @subschedule = schedule.subschedules.build(subschedule_params)

    if @subschedule.save
      render json: { subschedule: SUBSCHEDULE_SERIALIZER.new(@subschedule).as_json }, status: :ok
    else
      render json: { error: @subschedule.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    if @subschedule.update(subschedule_params)
      render json: { subschedule: SUBSCHEDULE_SERIALIZER.new(@subschedule).as_json }, status: :ok
    else
      render json: { error: @subschedule.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @subschedule.destroy
      render json: { message: 'SubSchedule deleted successfully' }, status: :ok
    else
      render json: { error: @subschedule.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def subschedule_params
      params.require(:subschedule).permit(:shift_start, :shift_end, :schedule_id)
    end
end
