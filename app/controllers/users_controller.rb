class UsersController < ApplicationController

  def show
    @user = User.all
  end

  def new
    @user = User.new
  end

end
