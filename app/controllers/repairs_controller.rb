class RepairsController < ApplicationController
  before_action :set_repair, only: %i(show edit update destroy edit_progress update_progress edit_contacted update_contacted update_delivery update_reminder)
  before_action :all_machine_category, only: %i(new create edit update)
  before_action :logged_in_user, only: %i(index new create show edit update destroy
                                          edit_progress update_progress edit_contacted update_contacted update_delivery update_reminder)

  UPDATE_ERROR_MSG = "エラー：データ更新がされませんでした。やり直してください。"

  def index
    # 検索フォームの入力値を取り出す
    hash = ActiveSupport::HashWithIndifferentAccess.new(search: params[:search])
    @search_hash = hash[:search]

    if params[:search] == ""
      redirect_to repairs_url
      flash[:danger] = "検索ワードが入力されていません。"
    else
      @repairs = Repair.paginate(page: params[:page], per_page: 15).search(params[:search]).
                        order(reminder: :DESC, delivery: :ASC, contacted: :ASC, progress: :ASC, reception_day: :DESC, created_at: :DESC)
      if params[:search].present?
        flash.now[:success] = "検索結果:&nbsp;#{@repairs.count}件&emsp;\"#{@search_hash}\""
      end
    end

    # CVS.PDF出力
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
        filename: "修理一覧(#{Date.current.try(:strftime, "%Y年%-m月%d日現在")}).csv", type: :csv
      end
      format.pdf do
        pdf = RepairPDF.new(@repairs)

        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.render,
          filename:    "修理一覧.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def new
    @repair = Repair.new
  end

  def create
    @repair = Repair.new(repair_params)
    if @repair.save
      flash[:success] = "#{@repair.customer_name}：修理受付"
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
      flash[:success] = "#{@repair.customer_name}の情報を更新しました。"
      redirect_to repairs_url
    else
      render :edit
    end
  end

  def destroy
    @repair.destroy
    flash[:danger] = "#{@repair.customer_name}の情報を削除しました。"
    redirect_to repairs_url
  end

  def edit_progress
    @users = User.where(admin: false).order(id: :ASC)
  end

  def update_progress
    if @repair.update_attributes(repair_completed_params)
      if @repair.progress == 2
        flash[:success] = "#{@repair.customer_name}：修理完了"
      elsif @repair.progress == 1
        flash[:warning] = "#{@repair.customer_name}：修理完了を解除しました。"
      else
        flash[:success] = "#{@repair.customer_name}：進捗情報を更新しました。"
      end
      redirect_to repairs_url
    else
      flash[:danger] = UPDATE_ERROR_MSG
      redirect_to repairs_url
    end
  end

  def edit_contacted
  end

  def update_contacted
    if @repair.contacted == 1
      if @repair.update_attributes(contacted: 2)
        flash[:success] = "#{@repair.customer_name}：連絡済"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @repair.contacted == 2
      if @repair.update_attributes(contacted: 1)
        flash[:warning] = "#{@repair.customer_name}：連絡済を解除しました。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to repairs_url
  end

  def update_delivery
    if @repair.delivery == 1
      if @repair.update_attributes(delivery: 2)
        @repair.update_attributes(reminder: 1)
        flash[:success] = "#{@repair.customer_name}：引渡し済"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @repair.delivery == 2
      if @repair.update_attributes(delivery: 1)
        flash[:warning] = "#{@repair.customer_name}：引渡し済を解除しました。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to repairs_url
  end

  def update_reminder
    if @repair.reminder == 1
      if @repair.update_attributes(reminder: 2)
        flash[:success] = "#{@repair.customer_name}：催促有り"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @repair.reminder == 2
      if @repair.update_attributes(reminder: 1)
        flash[:warning] = "#{@repair.customer_name}：催促解除"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to repairs_url
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
