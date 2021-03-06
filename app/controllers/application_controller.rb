class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'csv'
  include SessionsHelper
  include RepairsHelper

  $days_of_the_week = %w(日 月 火 水 木 金 土)

  def set_user
    @user = User.find(params[:id])
  end

  def set_repair
    @repair = Repair.find(params[:id])
  end

  def all_machine_category
    @machine_categories = MachineCategory.all.order(code: :ASC)
  end

  def set_machine_category
    @machine_category = MachineCategory.find(params[:id])
  end

  # 削除フラグの付いた修理レコード
  def repair_with_dele_flag
    @delete_flag_repairs = Repair.where(delete_check: 1)
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

  def correct_or_admin_user
    set_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      redirect_to root_url
      flash[:danger] = "アクセス権限がありません。"
    end
  end

  def editor_or_admin_user
    unless current_user.editor? || current_user.admin?
      redirect_to root_url
      flash[:danger] = "アクセス権限がありません。"
    end
  end
end
