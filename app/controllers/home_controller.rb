class HomeController < ApplicationController
  def index
    puts current_user.inspect
    puts "admin? #{current_user.admin?}"
  end

  def show
    @user = LDAP::User.find(current_user.login)
    render json: [@user]
  end
end
