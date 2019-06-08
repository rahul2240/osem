# frozen_string_literal: true

module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def late_booth

    end

    def create_late_booth
      if late_booth_params[:emails]
          emails_array = late_booth_params[:emails].split(",")

          emails_array.each do |email|
            if User.find_by(email: email).nil? || ((!User.find_by(email: email).confirmed? &&
                                                    !User.find_by(email: email).opted_out?))
              User.invite!({email: email}, current_user) do |user|
                user.invitation_message = "submit booth request " + @conference.title
              end
            end

          end
        end
      flashnow[:notice] = 'Successfully sent invitations'
      render 'late_booth'
    end

    private

    def late_booth_params
      params.require(:invite).permit(:emails)
    end
  end
end
