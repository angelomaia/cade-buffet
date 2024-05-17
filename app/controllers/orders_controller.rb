class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :index, :confirm, 
                                            :new_user_message, :user_cancel,
                                            :new_cancel_fine_charge, :cancel_with_fine]
  before_action :set_order_check_user, only: [:show, :confirm, :new_user_message, 
                                              :user_cancel, :new_cancel_fine_charge,
                                              :cancel_with_fine]
  before_action :authenticate_owner!, only: [:owner, :details, :evaluation, 
                                              :create_order_price, :new_buffet_message,
                                              :owner_cancel, :fine_paid]
  before_action :set_order_check_owner, only: [:details, :evaluation, :new_buffet_message,
                                              :owner_cancel, :fine_paid]
  before_action :check_expired_orders, only: [:owner, :index, :show, :details]
  
  def new
    buffet = Buffet.find(params[:buffet_id])

    if buffet.deactivated?
      redirect_to root_path, notice: 'O Buffet está desativado.'
    end

    @event_types = buffet.event_types.where(status: 'active')
    @order = Order.new
    @preset_event = params[:preset_event]
  end

  def create
    order_params = params.require(:order).permit(:event_type_id, :date, :guest_quantity, :details, 
                                                :location, :address, :city, :state, :zipcode)
    @order = Order.new(order_params)
    @order.buffet = @order.event_type.buffet

    if @order.buffet.deactivated?
      return redirect_to root_path, notice: 'O Buffet está desativado.'
    end

    if @order.event_type.deactivated?
      return redirect_to @order.buffet, notice: 'Esse Tipo de Evento está desativado.'
    end

    @order.user = current_user
    @order.build_chat

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

  def show
    @order_price = @order.order_price unless @order.order_price.nil?
    @chat = @order.chat
  end

  def index
    @user = current_user
    @pending_orders = Order.where(user: @user, status: 'pending')
    @approved_orders = Order.where(user: @user, status: 'approved')
    @confirmed_orders = Order.where(user: @user, status: 'confirmed')
    @cancelled_orders = Order.where(user: @user, status: 'cancelled')
  end

  def confirm
    if @order.order_price.expiration_date >= Date.today
      @order.confirmed!
      redirect_to @order, notice: 'Pedido confirmado com sucesso!'
    else
      redirect_to @order, alert: 'Proposta expirada.'
    end
  end

  def user_cancel
    @order.cancelled!
    redirect_to @order, notice: 'Pedido cancelado com sucesso!'
  end

  def owner_cancel
    @order.cancelled!
    redirect_to details_order_path(@order), notice: 'Pedido cancelado com sucesso!'
  end

  def details
    @orders = current_owner.buffet.orders.where(date: @order.date)
    @order_price = @order.order_price unless @order.order_price.nil?
    @chat = @order.chat
  end
  
  def evaluation
    @orders = current_owner.buffet.orders.where(date: @order.date)
    @order_price = OrderPrice.new(base: calculate_base_price(@order))
  end

  def create_order_price
    @order = Order.find(params[:id])
    @orders = current_owner.buffet.orders.where(date: @order.date)

    if @order.approved?
      old_price = @order.order_price
    end

    @order.order_price.destroy if @order.order_price != nil

    @order_price = OrderPrice.new(params.require(:order_price).permit(:discount, :fee, :payment, :description, :expiration_date))
    @order_price.discount ||= 0
    @order_price.fee ||= 0
    @order_price.base = calculate_base_price(@order)
    @order_price.total = @order_price.base - @order_price.discount + @order_price.fee
    @order_price.order = @order
    @order_price.event_type = @order.event_type
    @order_price.buffet = @order.buffet

    if @order_price.valid?
      @order_price.save!
      @order.update(status: 'approved')
      redirect_to details_order_path(@order), notice: 'Pedido aprovado com sucesso.'
    else
      @order.order_price = old_price.dup if old_price
      render :evaluation, alert: 'Não foi possível aprovar o pedido.'
    end
  end

  def owner
    @buffet = current_owner.buffet
    @pending_orders = Order.where(buffet: @buffet, status: 'pending')
    @approved_orders = Order.where(buffet: @buffet, status: 'approved')
    @confirmed_orders = Order.where(buffet: @buffet, status: 'confirmed')
    @cancelled_orders = Order.where(buffet: @buffet, status: 'cancelled')
  end
  
  def new_cancel_fine_charge
    cancel_fines = @order.event_type.cancel_fines
  
    applicable_fines = cancel_fines.select do |cancel_fine|
      (Date.today + cancel_fine.days.days) >= @order.date
    end
  
    if applicable_fines.any?
      applicable_fine = applicable_fines.min_by(&:days)
      @value = (applicable_fine.percentage.to_f * @order.order_price.total.to_f)/100.0
    else
      flash[:alert] = "Não foram encontradas Multas por Cancelamento."
    end
  end

  def cancel_with_fine
    value = params[:value]
    FineCharge.create!(order: @order, user: @order.user, buffet: @order.buffet, value: value)
    @order.cancelled!
    redirect_to @order, notice: 'Pedido cancelado com sucesso. Multa aplicada.'
  end

  def fine_paid
    fine = FineCharge.where(order: @order).first
    fine.paid!
    redirect_to details_order_path(@order), notice: 'Multa definida como Paga.'
  end

  def new_user_message
    @user_message = UserMessage.new(params.require(:user_message).permit(:content))
    @user_message.user = current_user
    @user_message.chat = @order.chat

    if @user_message.valid?
      @user_message.save!
      redirect_to @order, notice: 'Mensagem enviada com sucesso.'
    else
      redirect_to @order, notice: 'Não foi possível enviar a mensagem.'
    end
  end

  def new_buffet_message
    @buffet_message = BuffetMessage.new(params.require(:buffet_message).permit(:content))
    @buffet_message.buffet = current_owner.buffet
    @buffet_message.chat = @order.chat

    if @buffet_message.valid?
      @buffet_message.save!
      redirect_to details_order_path(@order), notice: 'Mensagem enviada com sucesso.'
    else
      redirect_to details_order_path(@order), notice: 'Não foi possível enviar a mensagem.'
    end
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

  def calculate_base_price(order)
    if order.date.saturday? && order.event_type.price.weekend? || order.date.sunday? && order.event_type.price.weekend?
      base_price = order.event_type.price.weekend_base
      extra_person_price = @order.event_type.price.weekend_extra_person
      min_people = order.event_type.min_people.to_f
      base_price + (extra_person_price * (order.guest_quantity - min_people))
    else
      base_price = order.event_type.price.base
      extra_person_price = @order.event_type.price.extra_person
      min_people = order.event_type.min_people.to_f
      base_price + (extra_person_price * (order.guest_quantity - min_people))
    end
  end

  def check_expired_orders
    expired_orders = Order.joins(:order_price)
                           .where('order_prices.expiration_date <= ?', Date.today)

    expired_orders.each do |expired_order|
      expired_order.cancelled!
    end
  end
  
  def event_type_deactivated?
    @event_type = EventType.find(params[:event_type_id])
    if @event_type.status == 'deactivated'
      flash[:alert] = "Esse Tipo de Evento está desativado."
      redirect_to root_path
    end
  end
end