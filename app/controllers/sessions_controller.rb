class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    flash[:success] = "Login realizado com sucesso!"
    redirect_to :root
  end
  def destroy
    session[:user_id] = nil
    flash[:success] = "Logout realizado com sucesso!"
    redirect_to :root
  end
  def failure
    flash[:failure] = "Ocorreu um erro ao realizar o login. Por favor, tente novamente."
    redirect_to :root
  end
end
