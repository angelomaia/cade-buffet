class CancelFinesController < ApplicationController
  def new
    @event_type = EventType.find(params[:event_type_id])
    @cancel_fine = CancelFine.new
  end

  def create
    @event_type = EventType.find(params[:event_type_id])

    if @event_type.buffet.owner == current_owner
      @cancel_fine = CancelFine.new(params.require(:cancel_fine).permit(:days, :percentage))
      @cancel_fine.event_type = @event_type
  
      if @cancel_fine.valid?
        @cancel_fine.save!
        return redirect_to event_type_path(@event_type), notice: 'Multa por Cancelamento registrada com sucesso.'
      else
        return render :new, alert: 'Não foi possível registrar a Multa por Cancelamento.'
      end
    else
      return redirect_to root_path, alert: 'Você não pode editar esse Tipo de Evento.'
    end
  end
end