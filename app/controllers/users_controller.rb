class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  # GET /users
  # GET /users.json
  def index
    @users = LDAP::User.all.sort_by(&:login)
    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # # GET /users/new
  # def new
  #   @user = User.new
  # end
  #
  # # GET /users/1/edit
  # def edit
  # end

  # POST /users
  # POST /users.json
  def create
    login = user_params[:login]
    first = user_params[:first_name]
    last = user_params[:last_name]
    key = user_params[:key]

    raise "not authorized" unless is_admin

    if login.blank? || first.blank? || last.blank? || key.blank?
      raise "all fields are required"
    elsif LDAP::User.create(login, first, last, key)
      render_success("user #{login} created.")
    else
      render_failure("failed to create user")
    end
  rescue => e
    render_failure(e.message)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    login = user_params[:login]

    raise "not authorized" unless is_admin || is_me(login)

    LDAP::User.update(login, user_params)
    render json: LDAP::User.find(login)
  rescue => e
    render_failure(e.message)
  end

  def disable
    login = params[:id]

    raise "not authorized" unless is_admin

    if LDAP::User.disable(login)
      render_success("login #{login} disabled!")
    else
      render_failure("could not disable user")
    end
  rescue => e
    render_failure(e.message)
  end

  def enable
    login = params[:id]

    raise "not authorized" unless is_admin

    if LDAP::User.enable(login)
      render_success("login #{login} enabled!")
    else
      render_failure("could not enable user")
    end
  rescue => e
    render_failure(e.message)
  end

  def password
    login = params[:id]
    password = params[:password]
    confirm = params[:confirmation]

    raise "not authorized" unless is_admin || is_me(login)

    if !login
      raise "login not set"
    elsif password != confirm
      raise "passwords do not match"
    elsif LDAP::User.password(login, password)
      render_success("password for #{login} changed!")
    else
      render_failure("failed to update password")
    end
  rescue => e
    render_failure(e.message)
  end

  # def name
  #   login = params[:login]
  #   name = params[:name]
  #   if !login
  #     raise "login not set"
  #   elsif LDAP::User.update(login, {name: name})
  #     render_success("name updated")
  #   end
  # rescue => e
  #   render json: {error: e.message}, status: :unprocessable_entity
  # end

  def add_group
    login = params[:user_id]
    group = params[:group]

    raise "not authorized" unless is_admin

    if !login || !group
      raise "login or group not set"
    elsif LDAP::User.add_group(login, group)
      render_success("user #{login} added to group #{group}")
    else
      render_failure("failed to add #{login} to group #{group}")
    end
  rescue => e
    render_failure(e.message)
  end

  def remove_group
    login = params[:user_id]
    group = params[:group]

    raise "not authorized" unless is_admin

    if !login || !group
      raise "login or group not set"
    elsif LDAP::User.remove_group(login, group)
      render_success("user #{login} removed from group #{group}")
    else
      render_failure("failed to remove #{login} from group #{group}")
    end
  rescue => e
    render_failure(e.message)
  end

  def add_key
    login = params[:user_id]
    key = params[:user][:key]
    key_name = key.split.last

    raise "not authorized" unless is_admin || is_me(login)

    if !login || !key
      raise "login or key not set"
    elsif LDAP::User.add_key(login, key)
      render_success("key '#{key_name}' added to user #{login}")
    else
      render_failure("failed to add key to #{login}")
    end
  rescue => e
    render_failure(e.message)
  end

  def remove_key
    login = params[:user_id]
    key = params[:key_name]

    raise "not authorized" unless is_admin || is_me(login)

    if !login || !key
      raise "login or key not set"
    elsif LDAP::User.remove_key(login, key)
      render_success("key '#{key}' removed from #{login}")
    else
      render_failure("failed to remove key from #{login}")
    end
  rescue => e
    render_failure(e.message)
  end

  # # DELETE /users/1
  # # DELETE /users/1.json
  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    id = params[:id] == 'me' ? current_user.login : params[:id]
    @user = LDAP::User.find(id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user]
  end
end
