class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(email: user_params[:signup_email], password: user_params[:signup_password])

    if @user.save
      redirect_to root_path, notice: 'Registrazione avvenuta con successo.'
    else
      render :new
    end
  end

  private

  def user_params
    params.permit(:signup_email, :signup_password, :policy)
  end
end


