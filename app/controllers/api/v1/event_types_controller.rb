class Api::V1::EventTypesController < Api::V1::ApiController
  def index
    buffet = Buffet.find(params[:buffet_id])
    events = buffet.event_types.includes(:price)

    events_json = events.map do |event_type|
      json_data = event_type.as_json(except: [:created_at, :updated_at])
      
      if event_type.price.present?
        json_data[:price] = event_type.price.as_json(except: [:created_at, :updated_at])
      end

      json_data
    end
    render status: 200, json: events_json
  end
end