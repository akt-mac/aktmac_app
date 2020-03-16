class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update editor_switch destroy)
  before_action :logged_in_user
  before_action :admin_user, only: %i(new create edit update destroy import)
  before_action :correct_or_admin_user, only: %i(show editor_switch)

  def index
    @users_all = User.all
    @users = User.paginate(page: params[:page], per_page: 10)

    # CSVF出力
    respond_to do |format|
      format.html
      format.csv do
        if current_user.admin?
          send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
          filename: "ユーザ一覧(#{DateTime.current&.strftime("%Y年%-m月%-d日%-H時%-M分現在")}).csv", type: :csv
        else
          redirect_to repairs_url
        end
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "新規ユーザー(#{@user.name})を作成しました。"
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

  def editor_switch
    if @user.update_attributes!(editor_params)
      flash[:success] = "#{@user.name}の編集権限を変更しました。"
      redirect_to @user
    end
  end

  def destroy
    @user.destroy
    flash[:danger] = "#{@user.name}のユーザー情報を削除しました。"
    redirect_to users_url
  end

  def import
    if params[:users_file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
      redirect_to data_management_repairs_url
    else
      num = User.import(params[:users_file])
      if num > 0
        flash[:success] = "#{num.to_s}件の情報を追加/更新しました。"
        redirect_to users_url
      else
        flash[:danger] = "読み込みエラーが発生しました。フォーマットを確認してください。"
        redirect_to data_management_repairs_url
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def editor_params
      params.require(:user).permit(:editor)
    end
end
