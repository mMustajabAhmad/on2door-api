class TaskChannel < ApplicationCable::Channel
  def subscribed
    @task = Task.find(params[:task_id])

    if authorized_to_subscribe?
      stream_from "task_#{@task.id}"
    else
      reject
    end
  end

  def update_location(data)
    if can_update_location?
      validate_location_data(data)

      ActionCable.server.broadcast(
        "task_#{@task.id}",
        {
          type: 'location_update',
          driver_id: current_user.id,
          driver_name: user_display_name,
          lat: data["lat"].to_f,
          lng: data["lng"].to_f,
          updated_at: Time.current.iso8601,
          task_id: @task.id,
          destination: {
            lat: @task.address&.latitude,
            lng: @task.address&.longitude
          }
        }
      )
    else
      reject
    end
  end

  def unsubscribed
    if @task
      ActionCable.server.broadcast("task_#{@task.id}", {
        type: 'user_left',
        user_id: current_user.id,
        user_type: current_user.class.name.downcase,
        user_name: user_display_name,
        timestamp: Time.current.iso8601
      })
    end
  end

  private
    def authorized_to_subscribe?
      return false unless @task
      return true if current_user.is_a?(Administrator) && current_user.organization_id == @task.organization_id
      return true if current_user == @task.driver
      false
    end

    def can_update_location?
      current_user == @task.driver && @task.active?
    end

    def validate_location_data(data)
      raise ArgumentError, "Latitude is required" unless data["lat"].present?
      raise ArgumentError, "Longitude is required" unless data["lng"].present?

      lat = data["lat"].to_f
      lng = data["lng"].to_f

      raise ArgumentError, "Invalid latitude" unless lat.between?(-90, 90)
      raise ArgumentError, "Invalid longitude" unless lng.between?(-180, 180)
    end


    def user_display_name
      "#{current_user.first_name} #{current_user.last_name}".strip
    end
end
