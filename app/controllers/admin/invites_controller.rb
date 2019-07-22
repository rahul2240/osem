module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def new
      @invite = @conference.invites.new
      @url = admin_conference_invitation_path(@conference.short_title)
    end

    def create

      emails_array = invite_params[:emails].split(',')

      emails_array.each do |email|
        @invite = @conference.invites.new(invite_params)
        new_user = User.find_by(email: email)
        if new_user.nil?
          new_user = User.invite!({ email: email }, current_user)
        end

        @invite.user_id = new_user.id
        if @invite.save
          puts 'yes'
        else
          flash.now[:error] = "Invitation failed due to some reasons."
          break
        end
      end
      redirect_to admin_conference_invitation_path
    end

    private
      def invite_params
        params.require(:invite).permit(:emails, :end_date, :content)
      end
  end
end
