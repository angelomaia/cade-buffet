class RatingsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @buffet = @order.buffet
    @event_type = @order.event_type

    @rating = Rating.new
  end

  def create
    @order = Order.find(params[:order_id])
    @buffet = @order.buffet
    @event_type = @order.event_type

    @rating = Rating.new(params.require(:rating).permit(:grade, :text, :photos))
    @rating.order = @order
    @rating.buffet = @buffet
    @rating.event_type = @event_type
    @rating.user = current_user

    if @rating.valid?
      @rating.save!
      redirect_to @order, notice: 'Avaliação enviada com sucesso.'
    else
      render :new, alert: 'Não foi possível enviar a avaliação.'
    end
  end
end