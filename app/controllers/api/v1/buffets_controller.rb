class Api::V1::BuffetsController < Api::V1::ApiController
  def index
    if params[:query].present?
      buffets = Buffet.left_joins(:event_types).where("buffets.name LIKE ?", 
                                                      "%#{params[:query]}%").order(name: :asc).distinct
      buffets = buffets.reject { |buffet| buffet.status == 'deactivated' }
    else
      buffets = Buffet.all.order(:name)
      buffets = buffets.reject { |buffet| buffet.status == 'deactivated' }
    end
    
    buffets_with_average_rating = buffets.map do |buffet|
      buffet.as_json(except: [:created_at, :updated_at]).merge(average_rating: buffet.average_rating)
    end

    render status: 200, json: buffets_with_average_rating
  end

  def show
    buffet = Buffet.find(params[:id])
    render status: 200, json: buffet.as_json(except: [:created_at, 
                                                      :updated_at, 
                                                      :corporate_name, 
                                                      :cnpj]).merge(average_rating: buffet.average_rating)
    end
end