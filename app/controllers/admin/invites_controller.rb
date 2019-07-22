module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def new; end

    def create; end
  end
end
