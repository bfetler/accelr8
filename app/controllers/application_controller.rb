class ApplicationController < ActionController::Base
  protect_from_forgery

# recommended by devise for signout redirect
  private
  def after_sign_out_path_for(resource_or_scope)

# fails   # it's a symbol?
#   if resource_or_scope.is_a?(AcceleratorUser)
#     accelerator_user_root_path
#   else
#     root_path
#   end

    after_sign_in_path_for(resource_or_scope)
  end
end
