class UsersController < ApplicationController
  def new
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
