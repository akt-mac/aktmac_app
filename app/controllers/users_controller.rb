class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index new create show edit update destroy)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規ユーザーを作成しました。"
      redirect_to users_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}の情報を更新しました。"
      redirect_to users_url
    else
      render :edit
    end
  end

  def destroy
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
