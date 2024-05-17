class SpecialOffersController < ApplicationController
  def new
    @event_type = EventType.find(params[:event_type_id])
    @special_offer = SpecialOffer.new
  end

  def create
    @event_type = EventType.find(params[:event_type_id])
    @special_offer = SpecialOffer.new(params.require(:special_offer).permit(:start, :end, :percentage))
    @special_offer.event_type = @event_type
    if @special_offer.valid?
      @special_offer.save!
      redirect_to @event_type, notice: "Promoção criada com sucesso!"
    else
      flash.now[:notice] = "Não foi possível criar a promoção."
      render 'new'
    end
  end
end