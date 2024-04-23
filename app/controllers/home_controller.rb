class HomeController < ApplicationController
  def index
    @buffets = Buffet.all
  end

  def choice
  end
end