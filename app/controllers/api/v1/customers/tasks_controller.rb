class Api::V1::Customers::TasksController < ApplicationController
  def show
    task = Task.includes(:address, :recipient).find_by(short_id: params[:short_id])

    return render json: { error: "Task not found" }, status: :not_found if task.nil?

    render json: { task: TASK_SERIALIZER.new(task).as_json }, status: :ok
  end
end
