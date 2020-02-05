class StaticPagesController < ApplicationController

  def top
    if logged_in?
      redirect_to repairs_url
    end
  end
end
