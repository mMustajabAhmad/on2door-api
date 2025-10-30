class ApplicationMailer < ActionMailer::Base
  require 'sendgrid-ruby'
  default from: 'on2door@gmail.com'
  layout 'mailer'

  private
    def send_sendgrid_email(to:, subject:, html_content:)
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

    def render_email_template(template_name, locals = {})
      render_to_string(
        template: template_name,
        formats: [:html],
        locals: locals
      )
    end
end
