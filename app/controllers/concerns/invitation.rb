module Invitation
  extend ActiveSupport::Concern

  def booth_responsible_invite
    if booth_params[:invite_responsible]
      emails_array = booth_params[:invite_responsible].split(',')

      emails_array.each do |email|
        new_user = User.find_by(email: email)
        if new_user.nil?
          User.invite!({ email: email }, current_user)
          new_user = User.find_by(email: email)
        else
          new_user = booth_responsible_reinvite(new_user)
        end
        if new_user && @booth.responsible_ids.exclude?(new_user.id)
          BoothRequest.create(booth_id: @booth.id, user_id: new_user.id,
                              role: 'responsible')
        end
      end
    end
  end

  def booth_responsible_reinvite(new_user)
    if booth_params[:reinvite]=="1"
      if new_user.last_sign_in_at.nil?
        new_user = User.invite!({ email: new_user.email }, current_user)
      end
    end
    new_user
  end
end
