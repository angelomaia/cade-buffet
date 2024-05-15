class RatingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @order = Order.find(params[:order_id])
    @buffet = @order.buffet
    @event_type = @order.event_type

    if @order.user == current_user
      @rating = Rating.new
    else
      redirect_to root_path, alert: 'Você não tem acesso a esse pedido.'
    end
  end

  def create
    @order = Order.find(params[:order_id])
    @buffet = @order.buffet
    @event_type = @order.event_type

    if @order.user == current_user
      @rating = Rating.new(params.require(:rating).permit(:grade, :text, :photos))
      @rating.order = @order
      @rating.buffet = @buffet
      @rating.event_type = @event_type
      @rating.user = current_user
  
      if @rating.valid?
        @rating.save!
        return redirect_to buffet_rating_path(@rating.buffet, @rating), notice: 'Avaliação enviada com sucesso.'
      else
        return render :new, alert: 'Não foi possível enviar a avaliação.'
      end
    else
      return redirect_to root_path, alert: 'Você não tem acesso a esse pedido.'
    end
  end

  def show
    @rating = Rating.find(params[:id])
    @buffet = Buffet.find(params[:buffet_id])
  end
end