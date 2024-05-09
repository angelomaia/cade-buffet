class Api::V1::BuffetsController < Api::V1::ApiController
  def index
    if params[:query].present?
      buffets = Buffet.left_joins(:event_types).where("buffets.name LIKE ?", 
                                                      "%#{params[:query]}%").order(name: :asc).distinct

      render status: 200, json: buffets.as_json(except: [:created_at, :updated_at])
    else
      buffets = Buffet.all.order(:name)
      render status: 200, json: buffets.as_json(except: [:created_at, :updated_at])
    end
  end

  def show
    buffet = Buffet.find(params[:id])
    render status: 200, json: buffet.as_json(except: [:created_at, :updated_at, :corporate_name, :cnpj])
  end
end