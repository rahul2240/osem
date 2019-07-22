module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def new
      @invite = Invite.new
      @url = admin_conference_invitation_path(@conference.short_title)
    end

    def create
      @invite = @conference.invites.new(invite_params)
      if @invite.save
        render 'new'
      else
        render 'new'
      end
    end

    private
      def invite_params
        params.require(:invite).permit(:emails, :end_date, :content)
      end
  end
end
