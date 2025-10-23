class Api::V1::Administrators::InvitationsController < Devise::InvitationsController
  before_action :authenticate_administrator!, only: [:create]

  def create
    authorize! :create, Administrator.new(role: params[:role])

    administrator = Administrator.invite!(
      {
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        phone_number: params[:phone_number],
        role: params[:role],
        is_read_only: params[:role] == 'dispatcher' ? params[:is_read_only] : false,
        is_account_owner: false,
        is_active: false,
        pending_team_ids: params[:role] == 'dispatcher' ? params[:team_ids] : nil
      },
      current_administrator
    )

    # Send email via SendGrid API directly
    send_invitation_email(administrator)

    render json: { administrator: ADMINISTRATOR_SERIALIZER.new(administrator).as_json }, status: :ok
  end

  private

  def send_invitation_email(administrator)
    require 'sendgrid-ruby'
    
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
    
    data = {
      personalizations: [
        {
          to: [{ email: administrator.email }],
          subject: "You have been invited to join OnFleet"
        }
      ],
      from: { email: 'on2door@gmail.com' },
      content: [
        {
          type: 'text/html',
          value: "<h1>You have been invited!</h1><p>Click <a href='#{accept_invitation_url(administrator, invitation_token: administrator.raw_invitation_token)}'>here</a> to accept your invitation.</p>"
        }
      ]
    }

    begin
      response = sg.client.mail._('send').post(request_body: data)
      Rails.logger.info "SendGrid email sent: #{response.status_code}"
    rescue => e
      Rails.logger.error "SendGrid email failed: #{e.message}"
    end
  end

  def update
    administrator = Administrator.accept_invitation!(
      params.permit(
      :invitation_token,
      :password,
      :password_confirmation
    ))

    administrator.assign_pending_teams

    if administrator.valid?
      render json: { administrator: ADMINISTRATOR_SERIALIZER.new(administrator).as_json }, status: :ok
    else
      render json: { error: administrator.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
