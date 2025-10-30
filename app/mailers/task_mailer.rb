class TaskMailer < ApplicationMailer
  def track_task(task)
    @task = task
    @recipient = task.recipient

    html_content = render_to_string(
      template: 'task_mailer/track_task',
      layout: false,
      formats: [:html]
    )

    send_sendgrid_email(
      to: @recipient.email,
      subject: "Track Your Delivery with On2Door",
      html_content: html_content
    )
  end

  def task_assigned(task, driver)
    @task = task
    @driver = driver
    @recipient = task.recipient
    @address = task.address

    html_content = render_email_template('task_mailer/task_assigned')

    send_sendgrid_email(
      to: driver.email,
      subject: "New task assigned: #{task.short_id}",
      html_content: html_content
    )
  end
end
