class BuffetsController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]
  before_action :set_buffet_check_owner, only: [:edit, :update, :deactivate, :activate]
  skip_before_action :redirect_owner_to_buffet_creation, only: [:new, :create]
  before_action :buffet_deactivated?, only: [:show]

  def new
    if current_owner.buffet == nil
      @buffet = Buffet.new
    else
      redirect_to buffet_path(current_owner.buffet.id), notice: 'Você já cadastrou um Buffet.'
    end
  end

  def show
    @buffet = Buffet.find(params[:id])
  end

  def create
    if current_owner.buffet == nil
      @buffet = Buffet.new(buffet_params)
      @buffet.owner = current_owner
      if @buffet.valid?
        @buffet.save!
        redirect_to @buffet, notice: "Buffet cadastrado com sucesso."
      else
        flash.now[:notice] = "Buffet não cadastrado."
        render 'new'
      end
    else
      redirect_to buffet_path(current_owner.buffet.id), notice: 'Você já cadastrou um Buffet.'
    end
  end

  def edit;  end
  
  def update
    if @buffet.update(buffet_params)
      redirect_to buffet_path(@buffet.id), notice: 'Buffet alterado com sucesso.'
    else
      flash.now[:notice] = "Não foi possível atualizar o Buffet"
      render 'edit'
    end
  end

  def deactivate
    @buffet.deactivated!
    redirect_to @buffet, notice: 'Buffet desativado com sucesso!'
  end

  def activate
    @buffet.active!
    redirect_to @buffet, notice: 'Buffet ativado com sucesso!'
  end

  def buffet_search
    @query = params["query"]
    buffets = Buffet.left_joins(:event_types).where("buffets.name LIKE :query OR 
                                                      buffets.city LIKE :query OR 
                                                      event_types.name LIKE :query", 
                                                      query: "%#{@query}%").order(name: :asc).distinct

    buffets_to_remove = buffets.select do |buffet|
      event_types = buffet.event_types
      event_type_names = event_types.pluck(:name)
      event_type_deactivated = event_types.any? { |event_type| event_type.status == 'deactivated' }
      
      query_matched_only_with_deactivated = event_type_names.any? { |name| name.downcase.include?(@query.downcase) } && 
                                            event_type_names.count == 1 && 
                                            event_type_deactivated
      
      query_matched_only_with_deactivated
    end
    
    buffets -= buffets_to_remove

    buffets = buffets.reject { |buffet| buffet.status == 'deactivated' }
    
    @buffets = buffets
  end

  private

  def buffet_params
    params.require(:buffet).permit(
      :name, :corporate_name,
      :cnpj, :address, :neighborhood,
      :city, :state, :email,
      :phone, :zipcode,
      :description, :pix,
      :debit, :credit, :cash)
  end

  def set_buffet_check_owner
    @buffet = Buffet.find(params[:id])
    if @buffet.owner != current_owner
      return redirect_to root_path, alert: 'Você não pode editar este Buffet.'
    end
  end

  def buffet_deactivated?
    @buffet = Buffet.find(params[:id])
    if @buffet.status == 'deactivated' && @buffet.owner != current_owner
      flash[:alert] = "Esse Buffet está desativado."
      redirect_to root_path
    end
  end
end