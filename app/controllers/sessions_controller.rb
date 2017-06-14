class SessionsController < ApplicationController
  def create
    session[:user_email] = auth_hash['info']['email']

    if authenticated?
      redirect_to '/'
    else
      render :plain => 'No autorizado', :status => 401
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end

  def failure
    render :plain => '403 Auth method has failed', :status => 403
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end