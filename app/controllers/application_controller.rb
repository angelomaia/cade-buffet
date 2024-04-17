class ApplicationController < ActionController::Base
  before_action :redirect_owner_to_buffet_creation
  before_action :set_buffet_for_owner

  private

  def set_buffet_for_owner
      @buffet = current_owner.buffet if owner_signed_in? && current_owner.buffet != nil
  end

  def redirect_owner_to_buffet_creation
    unless request.path == new_buffet_path || request.path == destroy_owner_session_path
      if owner_signed_in? && current_owner.buffet == nil
        redirect_to new_buffet_path
      end
    end
  end
end