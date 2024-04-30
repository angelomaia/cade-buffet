class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show]
  before_action :set_order_check_user, only: [:show]
  
  def new
    buffet = Buffet.find(params[:buffet_id])
    @event_types = buffet.event_types
    @order = Order.new
  end

  def create
    order_params = params.require(:order).permit(:event_type_id, :date, :guest_quantity, :details, 
                                                :location, :address, :city, :state)
    @order = Order.new(order_params)
    @order.buffet = @order.event_type.buffet
    @order.user = current_user

    if @order.valid?
      @order.save!
      redirect_to @order, notice: 'Pedido criado com sucesso.'
    else
      flash.now[:notice] = 'Não foi possível criar o pedido.'
      render :new
    end
  end

  def show; end

  private

  def set_order_check_user
    @order = Order.find(params[:id])
    if @order.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esse pedido.'
    end
  end
end