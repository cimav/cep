class HomeController < ApplicationController
  before_action :auth_required
  def index
  end
end
