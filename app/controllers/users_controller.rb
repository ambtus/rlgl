class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user]
      update_user
    elsif params[:new_weights]
      update_weight
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :weights)
    end

    def weight_params
      params.permit(:new_weights)[:new_weights]
    end

    def update_user
      @user.update(user_params)
      if @user.save
        flash[:notice] = 'Weights were succesfully replaced'
        redirect_to @user
      else
        render :edit
      end
    end

    def update_weight
      if @user.new_weights(weight_params)
        flash.now[:notice] = 'Weight was succesfully updated'
      else
        flash.now[:error] = 'Weight was not succesfully updated'
      end
      render :show
    end


end
