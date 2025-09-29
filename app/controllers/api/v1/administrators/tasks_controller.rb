class Api::V1::Administrators::TasksController < ApplicationController
  before_action :authenticate_administrator!
  load_and_authorize_resource

  def index
    q = @tasks.includes(:address, :recipient).ransack(params[:q])
    pagy, records = pagy(q.result, page: params[:page], limit: params[:per_page])

    render json: { tasks: TASK_SERIALIZER.new(records).as_json, total_count: pagy.count }, status: :ok
  end

  def show
    render json: { task: TASK_SERIALIZER.new(@task).as_json }, status: :ok
  end

  def create
    @task = Task.new(task_params.except(:linked_task_ids).merge(administrator: current_administrator))

    if @task.save
      @task.linked_task_ids = task_params[:linked_task_ids] if task_params[:linked_task_ids].present?
      render json: { task: TASK_SERIALIZER.new(@task).as_json }, status: :ok
    else
      render json: { error: @task.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: { task: TASK_SERIALIZER.new(@task).as_json }, status: :ok
    else
      render json: { error: @task.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: { message: 'Task deleted successfully' }, status: :ok
    else
      render json: { error: @task.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    def task_params
      params.require(:task).permit(
        :pickup_task,
        :complete_after,
        :complete_before,
        :destination_notes,
        :service_time,
        :quantity,
        :driver_id,
        :team_id,
        linked_task_ids: [],
        task_completion_requirements: [:customer_signature, :photo_of_delivery, :add_notes],
        recipient_attributes: [:name, :phone_number],
        address_attributes: [:name, :street, :street_number, :appartment, :city, :state, :postal_code, :country]
      )
    end
end
