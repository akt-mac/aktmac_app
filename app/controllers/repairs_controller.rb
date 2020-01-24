class RepairsController < ApplicationController
  before_action :set_repair, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index new create show edit update destroy)

  def index
    @repairs = Repair.paginate(page: params[:page], per_page: 10).order(reception_day: :DESC, created_at: :DESC)
  end

  def new
    @machine_categories = MachineCategory.all
    @repair = Repair.new
  end

  def create
    @repair = Repair.new(repair_params)
    if @repair.save
      flash[:success] = "#{@repair.customer_name}の修理受付をしました。"
      redirect_to repairs_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def repair_params
      params.require(:repair).permit(:reception_day,
                                     :customer_name,
                                     :address,:phone_number,
                                     :mobile_phone_number,
                                     :machine_model,
                                     :condition,
                                     :category,
                                     :note,
                                     :reception_number)
    end
end
