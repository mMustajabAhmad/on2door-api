class UserMailer < ApplicationMailer
  def invitation_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @opts = opts

    html_content = render_email_template('devise_mailer/invitation_instructions')

    send_sendgrid_email(to: record.email, html_content: html_content)
  end

  def reset_password_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @opts = opts

    html_content = render_email_template('devise_mailer/reset_password_instructions')

    send_sendgrid_email(to: record.email, html_content: html_content)
  end
end
