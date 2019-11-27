class WowsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]


  def new
    @wow = Wow.new
  end


  def index
  end

  def show
    @wow = Wow.find_by_id(params[:id])
    if @wow.blank?
    render plain: 'Not Found :(', status: :not_found
    end
  end


  def create
    @wow = current_user.wows.create(wow_params)
    if @wow.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def wow_params
    params.require(:wow).permit(:comment, :address)
  end


end
