# frozen_string_literal: true

module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def late_booth

    end

  end
end
