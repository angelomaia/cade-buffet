class EventTypesController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update, :set_price]
  before_action :set_event_type_check_owner, only: [:edit, :update, :set_price, :deactivate, :activate]
  before_action :event_type_deactivated?, only: [:show]

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

  def edit
    @event_type.build_price if !@event_type.price
  end

  def update
    if @event_type.update(event_type_params)
      redirect_to event_type_path(@event_type.id), notice: 'Tipo de Evento alterado com sucesso.'
    else
      flash.now[:notice] = "Não foi possível atualizar o Tipo de Evento"
      if @event_type.errors.details.keys.any? { |error_key| error_key.to_s.start_with?('price.') }
        render 'set_price'
      else
        render 'edit'
      end
    end
  end
  
  def deactivate
    @event_type.deactivated!
    redirect_to @event_type, notice: 'Tipo de Evento desativado com sucesso!'
  end
  
  def activate
    @event_type.active!
    redirect_to @event_type, notice: 'Tipo de Evento ativado com sucesso!'
  end

  def delete_photo
    @event_type = EventType.find(params[:event_type_id])
    photo = @event_type.gallery_photos.find(params[:photo_id])

    if @event_type.buffet != current_owner.buffet
      return redirect_to root_path, alert: 'Você não pode editar este Tipo de Evento.'
    end
    
    photo.purge
  
    redirect_to @event_type, notice: 'Foto apagada com sucesso.'
  end
  
  def set_price
    @event_type.price.destroy if @event_type.price
    @event_type.build_price
  end

  private

  def event_type_params
    params.require(:event_type).permit(
      :name, :description, :cover_photo,
      :min_people, :max_people,
      :duration, :menu, :alcohol,
      :decoration, :parking,
      :location, price_attributes: [:base, 
                                    :extra_person, 
                                    :extra_hour, 
                                    :weekend_base, 
                                    :weekend_extra_person, 
                                    :weekend_extra_hour],
                                    gallery_photos: [])
  end

  def set_event_type_check_owner
    @event_type = EventType.find(params[:id])
    if @event_type.buffet != current_owner.buffet
      return redirect_to root_path, alert: 'Você não pode editar este Tipo de Evento.'
    end
  end

  def event_type_deactivated?
    @event_type = EventType.find(params[:id])
    if @event_type.status == 'deactivated' && @event_type.buffet.owner != current_owner
      flash[:alert] = "Esse Tipo de Evento está desativado."
      redirect_to root_path
    end
  end
end