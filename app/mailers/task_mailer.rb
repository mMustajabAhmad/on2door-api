class TaskMailer < ActionMailer::Base
  require 'sendgrid-ruby'
  default from: 'on2door@gmail.com'

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
      subject: "Your order has been placed - Track your delivery",
      html_content: html_content
    )
  end

  private
    def send_sendgrid_email(to:, subject:, html_content:)
      # development: fall back to ActionMailer delivery (Mailcatcher) below
      if Rails.env.production?
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])

        data = {
          personalizations: [
            {
              to: [{ email: to }],
              subject: subject
            }
          ],
          from: { email: 'on2door@gmail.com' },
          content: [
            {
              type: 'text/html',
              value: html_content
            }
          ]
        }

        begin
          response = sg.client.mail._('send').post(request_body: data)
          Rails.logger.info "SendGrid email sent: #{response.status_code}"
        rescue => e
          Rails.logger.error "SendGrid email failed: #{e.message}"
        end
      else
        # development - Mailcatcher
        mail(
          to: to,
          subject: subject,
          body: html_content,
          content_type: 'text/html'
        )
      end
    end
end
