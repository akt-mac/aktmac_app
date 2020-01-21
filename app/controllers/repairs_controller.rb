class RepairsController < ApplicationController
  before_action :logged_in_user, only: %i(index new create show edit update destroy)

  def index
  end

  def new
  end

  def create
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
      params.require(:repair).permit()
    end
end
