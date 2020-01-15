class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    flash[:success] = "テスト"
    redirect_to root_url
  end

  def show
    @user = User.find(params[:id])
  end

end
