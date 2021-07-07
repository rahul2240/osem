# frozen_string_literal: true

module Admin
  class EmailsController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title
    load_and_authorize_resource class: EmailSettings

    def update
      if @conference.email_settings.update(email_params)
        redirect_to admin_conference_emails_path(
                    @conference.short_title),
                    notice: 'Email settings have been successfully updated.'
      else
        redirect_to admin_conference_emails_path(
                    @conference.short_title),
                    error: "Updating email settings failed. #{@conference.email_settings.errors.to_a.join('. ')}."
      end
    end

    def index
      authorize! :index, @conference.email_settings
      @settings = @conference.email_settings
    end

    def new_custom_email
      subscriber_ids = @conference.subscriptions.pluck(:user_id)
      booths_responsible_ids = BoothRequest.where(booth_id: @conference.booth_ids).pluck(:user_id)
      confirmed_booth_ids = BoothRequest.where(booth_id: @conference.confirmed_booths.ids).pluck(:user_id)

      @keys = Hash.new()
      @keys['Users'] = User.pluck(:email)
      @keys['Subscribers'] = User.find(subscriber_ids).pluck(:email)
      @keys['BoothsResponsible'] = User.find(booths_responsible_ids.uniq).pluck(:email)
      @keys['ConfirmedBooths'] = User.find(confirmed_booth_ids.uniq).pluck(:email)
    end

    def custom_email
      emails_array = custom_email_params[:to].split(',')
      subject = custom_email_params[:subject]
      body = custom_email_params[:body]
      emails_array.each do |email|
        Mailbot.send_custom_mail(@conference, email, subject, body).deliver_now
      end
      render 'new_custom_email'

    end

    private

    def email_params
      params.require(:email_settings).permit(:send_on_registration,
                                             :send_on_accepted, :send_on_rejected, :send_on_confirmed_without_registration,
                                             :send_on_submitted_proposal,
                                             :submitted_proposal_subject, :submitted_proposal_body,
                                             :registration_subject, :accepted_subject, :rejected_subject, :confirmed_without_registration_subject,
                                             :registration_body, :accepted_body, :rejected_body, :confirmed_without_registration_body,
                                             :send_on_conference_dates_updated, :conference_dates_updated_subject, :conference_dates_updated_body,
                                             :send_on_conference_registration_dates_updated, :conference_registration_dates_updated_subject, :conference_registration_dates_updated_body,
                                             :send_on_venue_updated, :venue_updated_subject, :venue_updated_body,
                                             :send_on_cfp_dates_updated, :cfp_dates_updated_subject, :cfp_dates_updated_body,
                                             :send_on_program_schedule_public, :program_schedule_public_subject, :program_schedule_public_body,
                                             :send_on_booths_acceptance, :booths_acceptance_subject, :booths_acceptance_body,
                                             :send_on_booths_rejection, :booths_rejection_subject, :booths_rejection_body)
    end

    def custom_email_params
      params.require(:admin_email).permit(:to, :subject, :body)
    end
  end
end
