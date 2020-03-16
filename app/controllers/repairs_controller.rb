class RepairsController < ApplicationController
  before_action :set_repair, only: %i(show show_sub edit update destroy edit_progress update_progress edit_contacted update_contacted update_delivery update_reminder)
  before_action :all_machine_category, only: %i(new create edit update)
  before_action :admin_user, only: %i(data_management destroy import)
  before_action :editor_or_admin_user, only: %i(edit update update_progress update_contacted update_delivery update_reminder)
  before_action :logged_in_user

  UPDATE_ERROR_MSG = "エラー：データ更新がされませんでした。やり直してください。"

  def index
    # 検索フォームの入力値を取り出す
    # hash = ActiveSupport::HashWithIndifferentAccess.new(search: params[:search])
    # @search_hash = hash[:search]
    @search_params = reception_day_search_params

    if @search_params[:customer_name] == "" && @search_params[:reception_day_from] == "" && @search_params[:reception_day_to] == ""
      redirect_to repairs_url
      flash[:danger] = "検索ワードが入力されていません。"
    else
      @repairs_all = Repair.all
      @repairs = Repair.paginate(page: params[:page], per_page: 20).search(@search_params).
                        order(reminder: :DESC, delivery: :ASC, contacted: :ASC, progress: :ASC, reception_day: :DESC, created_at: :DESC)
      unless @search_params.blank?
        flash.now[:success] = "検索結果:&nbsp;#{@repairs.count}件&emsp;
                                             #{@search_params[:customer_name]}&emsp;
                                             #{(@search_params[:reception_day_from].to_date)&.strftime("%Y年%-m月%-d日")}
                                             #{from_to_text(@search_params[:reception_day_from], @search_params[:reception_day_to])}
                                             #{(@search_params[:reception_day_to].to_date)&.strftime("%Y年%-m月%-d日")}"
      end
    end

    # CSV.PDF出力
    respond_to do |format|
      format.html
      format.csv do
        if current_user.admin? # 管理者のみCVS出力可
          send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
          filename: "修理一覧(#{DateTime.current&.strftime("%Y年%-m月%-d日%-H時%-M分現在")}).csv", type: :csv
        else
          redirect_to repairs_url
        end
      end
      format.pdf do
        @repairs_pdf = Repair.search(@search_params).order(reception_day: :ASC)
        pdf = RepairPDF.new(@repairs_pdf)

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
    @progress_edit = false
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
    @url = show_sub_repair_url
  end

  def show_sub
  end

  def edit
    @progress_edit = true
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

  def export
    @reception_year = Repair.all.order(reception_day: :DESC).group_by { |ry| ry.reception_day.strftime("%Y") }
    @reception_month = Repair.all.order(reception_day: :DESC).group_by { |rm| rm.reception_day.strftime("%Y%m") }
  end

  def export_pdf
    @params_date = params[:date]
    @reception_year = Repair.all.order(reception_day: :ASC).group_by { |ry| ry.reception_day.strftime("%Y") }
    @reception_month = Repair.all.order(reception_day: :ASC).group_by { |rm| rm.reception_day.strftime("%Y%m") }
    respond_to do |format|
      format.html
      format.pdf do
        # @repairs_pdf = Repair.search(@search_params).order(reception_day: :ASC)
        @date = @params_date
        @year_pdf = @reception_year
        @month_pdf = @reception_month
        pdf = RepairPDF.new(@year_pdf, @month_pdf, @date)

        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.render,
          filename:    "修理一覧.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def data_management
  end

  def import
    if params[:repairs_file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
      redirect_to data_management_repairs_url
    else
      num = Repair.import(params[:repairs_file])
      flash[:success] = "#{num.to_s}件の情報を追加/更新しました。"
      redirect_to repairs_url
    end
  end

  private

    def repair_params
      params.require(:repair).permit(:reception_day,
                                     :customer_name,
                                     :address,
                                     :phone_number,
                                     :mobile_phone_number,
                                     :machine_model,
                                     :condition,
                                     :category,
                                     :note,
                                     :reception_number,
                                     :progress,
                                     :contacted,
                                     :delivery,
                                     :reminder)
    end

    # 修理進捗更新
    def repair_completed_params
      params.require(:repair).permit(:progress, :repair_staff, :completed)
    end

    # 受付日範囲検索
    def reception_day_search_params
      params.fetch(:search, {}).permit(:customer_name, :reception_day_from, :reception_day_to)
    end
end
