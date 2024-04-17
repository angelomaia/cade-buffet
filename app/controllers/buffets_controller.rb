class BuffetsController < ApplicationController
  before_action :authenticate_owner!
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
end