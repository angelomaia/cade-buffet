class ApplicationController < ActionController::Base
  before_action :redirect_owner_to_buffet_creation

  private

  def redirect_owner_to_buffet_creation
    if owner_signed_in? && current_owner.buffet_id.blank? && request.path != new_buffet_path && request.path != destroy_owner_session_path
      redirect_to new_buffet_path
    end
  end
end
