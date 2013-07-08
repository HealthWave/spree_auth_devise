require File.expand_path('../../base_controller_decorator', __FILE__)
Spree::Admin::UsersController.class_eval do
  if Spree.user_class.const_defined?("DestroyWithOrdersError")
    rescue_from "#{Spree.user_class}::DestroyWithOrdersError".constantize, :with => :user_destroy_with_orders_error
  end

  update.after :sign_in_if_change_own_password

  before_filter :load_roles, :only => [:edit, :new, :update, :create]

  private

    def sign_in_if_change_own_password
      if spree_current_user == @user && @user.password.present?
        sign_in(@user, :event => :authentication, :bypass => true)
      end
    end

    def load_roles
      @roles = Spree::Role.scoped
    end
end

