class RatingsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @wow = Wow.find_by_id(params[:wow_id])
    return render_not_found if @wow.blank?
    @wow.ratings.create(rating_params.merge(user: current_user))
    redirect_to root_path
  end

  private


  def rating_params
    params.require(:rating).permit(:comment)
  end
end
