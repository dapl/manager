class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  # check if we're admin
  def is_admin
    current_user.admin?
  end

  # check if we're the user
  def is_me(login)
    current_user.login == login
  end

  # helper for rendering success
  def render_success(message)
    render json: {success: true, message: message}, status: :ok
  end

  # helper for rendering failure
  def render_failure(message)
    logger.error "failure: #{message}"
    render json: {success: false, error: message}, status: :unprocessable_entity
  end
end
