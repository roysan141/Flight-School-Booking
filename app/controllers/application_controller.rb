class ApplicationController < ActionController::Base
  layout :layout_for_user

  private

  def layout_for_user
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
end
