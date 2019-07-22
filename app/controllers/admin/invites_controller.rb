module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def new
      @invite = Invite.new
      @url = admin_conference_invitation_path(@conference.short_title)
    end

    def create; end
  end
end
