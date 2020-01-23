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
      flash[:success] = "#{@machine_category.product}を登録しました。"
      redirect_to machine_categories_url
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def machine_category_params
      params.require(:machine_category).permit(:code, :product)
    end
end
