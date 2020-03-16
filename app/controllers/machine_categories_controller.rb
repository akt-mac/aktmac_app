class MachineCategoriesController < ApplicationController
  before_action :set_machine_category, only: %i(edit update destroy)
  before_action :logged_in_user
  before_action :admin_user

  def index
    @machine_categories_all = MachineCategory.all
    @machine_categories = MachineCategory.all.order(code: :ASC)

    # CSVF出力
    respond_to do |format|
      format.html
      format.csv do
        if current_user.admin?
          send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
          filename: "製品カテゴリ一覧(#{DateTime.current&.strftime("%Y年%-m月%-d日%-H時%-M分現在")}).csv", type: :csv
        else
          redirect_to repairs_url
        end
      end
    end
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

  def import
    if params[:machine_categories_file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
      redirect_to data_management_repairs_url
    else
      num = MachineCategory.import(params[:machine_categories_file])
      if num > 0
        flash[:success] = "#{num.to_s}件の情報を追加/更新しました。"
        redirect_to machine_categories_url
      else
        flash[:danger] = "読み込みエラーが発生しました。フォーマットを確認してください。"
        redirect_to data_management_repairs_url
      end
    end
  end

  private

    def machine_category_params
      params.require(:machine_category).permit(:code, :product)
    end
end
