class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  $days_of_the_week = %w(日 月 火 水 木 金 土)

  def set_user
    @user = User.find(params[:id])
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  def correct_user
    unless current_user?(@user)
      redirect_to root_url
      flash[:danger] = "アクセス権限がありません。"
    end
  end

  def admin_user
    unless current_user.admin?
      redirect_to root_url
      flash[:danger] = "アクセス権限がありません。"
    end
  end
end
