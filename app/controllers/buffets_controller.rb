class BuffetsController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]
  before_action :set_buffet_check_owner, only: [:edit, :update]
  skip_before_action :redirect_owner_to_buffet_creation, only: [:new, :create]

  def new
    @buffet = Buffet.new
  end

  def show
    @buffet = Buffet.find(params[:id])
  end

  def create
    @buffet = Buffet.new(buffet_params)
    @buffet.owner = current_owner
    if @buffet.valid?
      @buffet.save!
      redirect_to @buffet, notice: "Buffet cadastrado com sucesso."
    else
      flash.now[:notice] = "Buffet não cadastrado."
      render 'new'
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
end