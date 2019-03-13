class UsersController < ApplicationController

  def show
    @user = User.all
  end

  def edit
  end

  def update
    if current_user.update!(user_params)
      redirect_to edit_user_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :phone)
    end
end
