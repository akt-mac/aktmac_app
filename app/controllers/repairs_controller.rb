class RepairsController < ApplicationController
  before_action :set_repair, only: %i(show edit update destroy edit_progress update_progress)
  before_action :all_machine_category, only: %i(new edit)
  before_action :logged_in_user, only: %i(index new create show edit update destroy edit_progress update_progress)

  def index
    @repairs = Repair.paginate(page: params[:page], per_page: 10).order(reception_day: :DESC, created_at: :DESC)
  end

  def new
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
    if @repair.update_attributes(repair_params)
      flash[:success] = "#{@repair.customer_name}の修理を完了しました。"
      redirect_to repairs_url
    else
      rendr :edit
    end
  end

  def destroy
    @repair.destroy
    flash[:danger] = "#{@repair.customer_name}の情報を削除しました。"
    redirect_to repairs_url
  end

  def edit_progress
    @users = User.all
  end

  def update_progress
    if @repair.update_attributes(repair_completed_params)
      flash[:success] = "#{@repair.customer_name}の修理を完了しました。"
      redirect_to repairs_url
    else
      flash[:danger] = "エラー：進捗更新がされませんでした。やり直してください。"
      redirect_to repairs_url
    end
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

    # 修理進捗更新
    def repair_completed_params
      params.require(:repair).permit(:progress, :repair_staff, :completed)
    end
end
