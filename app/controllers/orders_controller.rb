class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :index]
  before_action :set_order_check_user, only: [:show]
  before_action :authenticate_owner!, only: [:owner, :details]
  before_action :set_order_check_owner, only: [:details]
  
  def new
    buffet = Buffet.find(params[:buffet_id])
    @event_types = buffet.event_types
    @order = Order.new
  end

  def create
    order_params = params.require(:order).permit(:event_type_id, :date, :guest_quantity, :details, 
                                                :location, :address, :city, :state, :zipcode)
    @order = Order.new(order_params)
    @order.buffet = @order.event_type.buffet
    @order.user = current_user

    if @order.valid?
      @order.save!
      redirect_to @order, notice: 'Pedido criado com sucesso.'
    else
      @buffet = @order.buffet
      @event_types = @buffet.event_types
      flash.now[:notice] = 'Não foi possível criar o pedido.'
      render :new
    end
  end

  def show; end

  def index
    @user = current_user
    @pending_orders = Order.where(user: @user, status: 'pending')
    @approved_orders = Order.where(user: @user, status: 'approved')
    @confirmed_orders = Order.where(user: @user, status: 'confirmed')
    @cancelled_orders = Order.where(user: @user, status: 'cancelled')
  end

  def details
    @orders = current_owner.buffet.orders.where(date: @order.date)
  end

  def owner
    @buffet = current_owner.buffet
    @pending_orders = Order.where(buffet: @buffet, status: 'pending')
    @approved_orders = Order.where(buffet: @buffet, status: 'approved')
    @confirmed_orders = Order.where(buffet: @buffet, status: 'confirmed')
    @cancelled_orders = Order.where(buffet: @buffet, status: 'cancelled')
  end

  private

  def set_order_check_owner
    @order = Order.find(params[:id])
    if @order.buffet.owner != current_owner
      return redirect_to root_path, alert: 'Você não possui acesso a esse pedido.'
    end
  end

  def set_order_check_user
    @order = Order.find(params[:id])
    if @order.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a esse pedido.'
    end
  end
end