class Api::V1::EventTypesController < Api::V1::ApiController
  def index
    buffet = Buffet.find(params[:buffet_id])
    events = buffet.event_types.includes(:price)
    events = events.reject { |events| events.status == 'deactivated' }

    events_json = events.map do |event_type|
      json_data = event_type.as_json(except: [:created_at, :updated_at])
      
      if event_type.price.present?
        json_data[:price] = event_type.price.as_json(except: [:created_at, :updated_at])
      end

      json_data
    end
    render status: 200, json: events_json
  end

  def availability_check
    event = EventType.find(params[:event_type_id])
    date = params[:date].to_date
    guests = params[:guests].to_f
    warnings = []

    future_date = true if date > Date.today

    date_conflict = event.orders.where(date: date, status: ['approved', 'confirmed'])
    
    if date_conflict.empty?
      if guests <= event.max_people.to_f
        if date.saturday? && event.price.weekend? || date.sunday? && event.price.weekend?
          base_price = event.price.weekend_base
          extra_person_price = event.price.weekend_extra_person
          min_people = event.min_people.to_f
          value = base_price + (extra_person_price * (guests - min_people))

          result = { 'price': value }
        else
          base_price = event.price.base
          extra_person_price = event.price.extra_person
          min_people = event.min_people.to_f
          value = base_price + (extra_person_price * (guests - min_people))

          result = { 'price': value }
        end
      else
        warnings << 'Quantidade de convidados acima do limite.'

        result = { 'warnings': warnings }
      end
    else
      warnings << 'O Buffet já possui um evento marcado para esta data.'

      result = { 'warnings': warnings }
    end
    
    result = { 'warnings': ['A data do evento deve ser no futuro.'] } if future_date != true

    render status: 200, json: result.as_json
  end
end