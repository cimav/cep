class UsersController < ApplicationController
  before_action :auth_required

  def index
  end

  def new
    @user = User.new
  end

  def edit
  end
end
