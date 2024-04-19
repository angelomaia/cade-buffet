class EventTypesController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]
  before_action :set_event_type_check_owner, only: [:edit, :update]

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(event_type_params)
    @event_type.buffet = current_owner.buffet
    if @event_type.valid?
      @event_type.save!
      redirect_to @event_type, notice: "Tipo de Evento cadastrado com sucesso."
    else
      flash.now[:notice] = "Tipo de Evento não cadastrado."
      render 'new'
    end
  end

  def show
    @event_type = EventType.find(params[:id])
  end

  def edit; end

  def update
    if @event_type.update(event_type_params)
      redirect_to event_type_path(@event_type.id), notice: 'Tipo de Evento alterado com sucesso.'
    else
      flash.now[:notice] = "Não foi possível atualizar o Tipo de Evento"
      render 'edit'
    end
  end

  private

  def event_type_params
    params.require(:event_type).permit(
      :name, :description,
      :min_people, :max_people,
      :duration, :menu, :alcohol,
      :decoration, :parking,
      :location)
  end

  def set_event_type_check_owner
    @event_type = EventType.find(params[:id])
    if @event_type.buffet != current_owner.buffet
      return redirect_to root_path, alert: 'Você não pode editar este Tipo de Evento.'
    end
  end
end