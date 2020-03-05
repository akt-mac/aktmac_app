class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index new create show edit update destroy)
  before_action :admin_user, only: %i(new create edit update destroy)
  # before_action :correct_user, only: %i(edit update)

  def index
    @users_all = User.all
    @users = User.paginate(page: params[:page], per_page: 10)

    # CSVF出力
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
        filename: "ユーザ一覧(#{DateTime.current&.strftime("%Y年%-m月%-d日%-H時%-M分現在")}).csv", type: :csv
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
      flash[:success] = "#{num.to_s}件の情報を追加/更新しました。"
      redirect_to users_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
