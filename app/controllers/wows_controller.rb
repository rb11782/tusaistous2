class WowsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  def destroy
    @wow = Wow.find_by_id(params[:id])
    return render_not_found if @wow.blank?
    return render_not_found(:forbidden) if @wow.user != current_user
    @wow.destroy
    redirect_to root_path
  end
  

  def update
    @wow = Wow.find_by_id(params[:id])
    return render_not_found if @wow.blank?
    return render_not_found(:forbidden) if @wow.user != current_user
    @wow.update_attributes(wow_params)
    if @wow.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end

  end
  

  def new
    @wow = Wow.new
  end


  def index
  end


  def show
    @wow = Wow.find_by_id(params[:id])
    return render_not_found if @wow.blank?
  end

  def edit
    @wow = Wow.find_by_id(params[:id])
    return render_not_found if @wow.blank?
    return render_not_found(:forbidden) if @wow.user != current_user
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

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end


end
