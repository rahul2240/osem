# frozen_string_literal: true

module Admin
  class InvitesController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title

    def late_booth

    end

    def create_late_booth
      print(late_booth_params[:emails])
      render 'late_booth'
    end

    private

    def late_booth_params
      params.require(:invite).permit(:emails)
    end
  end
end
