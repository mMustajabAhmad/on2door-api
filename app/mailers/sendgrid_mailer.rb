class SendgridMailer < ActionMailer::Base
  require 'sendgrid-ruby'

  def invitation_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @opts = opts

    # Render the Devise template as HTML
    html_content = render_to_string(
      template: 'devise/mailer/invitation_instructions',
      layout: false,
      formats: [:html]
    )

    # Send via SendGrid API
    send_sendgrid_email(
      to: record.email,
      subject: 'You have been invited to join OnFleet',
      html_content: html_content
    )
  end

  def reset_password_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @opts = opts

    # Render the Devise template
    html_content = render_to_string(
      template: 'devise/mailer/reset_password_instructions',
      layout: false,
      formats: [:html]
    )

    # Send via SendGrid API
    send_sendgrid_email(
      to: record.email,
      subject: 'Reset your password',
      html_content: html_content
    )
  end

  private

  def send_sendgrid_email(to:, subject:, text_content: nil, html_content: nil)
    return unless Rails.env.production?

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
    
    content = []
    content << { type: 'text/plain', value: text_content } if text_content
    content << { type: 'text/html', value: html_content } if html_content
    
    data = {
      personalizations: [
        {
          to: [{ email: to }],
          subject: subject
        }
      ],
      from: { email: 'on2door@gmail.com' },
      content: content
    }

    begin
      response = sg.client.mail._('send').post(request_body: data)
      Rails.logger.info "SendGrid email sent: #{response.status_code}"
    rescue => e
      Rails.logger.error "SendGrid email failed: #{e.message}"
    end
  end
end
