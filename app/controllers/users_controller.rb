class UsersController < ApplicationController
  before_action :auth_required

  def index
    @admins = User.where(user_type:User::ADMIN)
    @ceps = User.where(user_type:User::CEP)
    render layout: false
  end

  def new
    @user = User.new
    render layout: false
  end

  def edit
    @user = User.find(params[:id])
    render layout: false
  end


  def create
    user = User.new(user_params)
    response = {}
    respond_to do |format|
      if user.save
        response[:redirect_url] = "users"
        response[:message] = "Se creó exitosamente al usuario: #{user.name}"
      else
        response[:redirect_url] = "users/new"
        response[:message] = "Error al crear usuario"
      end
      response[:object] = user
      format.json {render json:response}
    end
  end

  def update
    response = {}
    respond_to do |format|
      if is_admin?
        user = User.find(params[:id])
        if user.update(user_params)
          response[:message]  = "Se actualizó al usuario: #{user.name}"
          response[:redirect_url] = "users"
        else
          response[:message] = "Error al actualizar usuario"
          response[:redirect_url] = "users/#{user.id}"
          render :edit
        end
      else
        response[:message] = "Sólo el administrador puede realizar esta acción"
      end
      format.json {render json:response}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :user_type)
  end
end
