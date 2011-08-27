class ApplicationController < ActionController::Base
  protect_from_forgery

# recommended by devise for signout redirect
  private
  def after_sign_out_path_for(resource_or_scope)
#   accelerator_user_root_path
# needs to go to root_path if not accelerator
#   root_path

# fails
#   if resource_or_scope.is_a?(AcceleratorUser)
#     accelerator_user_root_path
#   else
#     root_path
#   end

#   scope = Devise::Mapping.find_scope!(resource_or_scope)
#   home_path = "#{scope}_root_path"
#   respond_to?(home_path, true) ? send(home_path) : root_path

    after_sign_in_path_for(resource_or_scope)
  end
end
