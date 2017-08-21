class UsersController < ApplicationController
  before_action :auth_required

  def index
    @admins = User.where(user_type:User::ADMIN)
    @ceps = User.where(user_type:User::CEP)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end


  def create
    user = User.new(user_params)
    response = {}
    respond_to do |format|
      if user.save

        response[:message] = "Se creó exitosamente al usuario: #{user.name}"
      else
        response[:message] = "Error al crear usuario"
      end
      response[:object] = user
      format.json {render json:response}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :user_type)
  end
end
