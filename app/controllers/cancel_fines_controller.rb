class CancelFinesController < ApplicationController
  def new
    @event_type = EventType.find(params[:event_type_id])
    @cancel_fine = CancelFine.new
  end

  def create
    
  end
end