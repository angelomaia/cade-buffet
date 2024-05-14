class HomeController < ApplicationController
  def index
    @buffets = Buffet.where(status: 'active')
  end

  def choice
  end
end