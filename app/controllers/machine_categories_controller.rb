class MachineCategoriesController < ApplicationController
  before_action :set_machine_category, only: %i(edit update destroy)
  before_action :logged_in_user, only: %i(index new create edit update destroy)

  def index
    @machine_categories = MachineCategory.all
  end

  def new
    @machine_category = MachineCategory.new
  end

  def create
    @machine_category = MachineCategory.new(machine_category_params)
    if @machine_category.save
      flash[:success] = "製品種目「#{@machine_category.product}」を登録しました。"
      redirect_to machine_categories_url
    else
      flash[:danger] = @machine_category.errors.full_messages.join("<br>").html_safe
      redirect_to machine_categories_url
    end
  end

  def edit
  end

  def update
    if @machine_category.update_attributes(machine_category_params)
      flash[:success] = "「#{@machine_category.product}」の情報を更新しました。"
      redirect_to machine_categories_url
    else
      flash[:danger] = @machine_category.errors.full_messages.join("<br>").html_safe
      redirect_to machine_categories_url
    end
  end

  def destroy
    @machine_category.destroy
    flash[:danger] = "「#{@machine_category.product}」を削除しました。"
    redirect_to machine_categories_url
  end

  private

    def machine_category_params
      params.require(:machine_category).permit(:code, :product)
    end
end
