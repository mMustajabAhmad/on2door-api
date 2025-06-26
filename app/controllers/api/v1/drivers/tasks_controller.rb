class Api::V1::Drivers::TasksController < ApplicationController
  before_action :authenticate_driver!
  load_and_authorize_resource

  def index
    q = @tasks.includes(:address, :recipient).ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { tasks: TASK_SERIALIZER.new(records).as_json, total_count: pagy.count }, status: :ok
  end

  def show
    @task = Task.includes(:address, :recipient).find(@task.id)
    render json: { task: TASK_SERIALIZER.new(@task).as_json }, status: :ok
  end

  def update
    if @task.update(task_params)
      render json: { task: TASK_SERIALIZER.new(@task).as_json }, status: :ok
    else
      render json: { error: @task.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def task_params
      params.require(:task).permit(
        :service_time,
        :state
      )
    end
end
