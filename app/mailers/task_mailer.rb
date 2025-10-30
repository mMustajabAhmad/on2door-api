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
end
