class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = LDAP::Group.all.sort_by(&:name)
    render json: @groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    render json: @group
  end

  # # GET /groups/new
  # def new
  #   @group = Group.new
  # end

  # # GET /groups/1/edit
  # def edit
  # end

  def add_user
    name = params[:group_id]
    user = group_params[:user]

    raise "not authorized" unless is_admin

    if !name || !user
      raise "user or group not set!"
    elsif LDAP::Group.add_user(name, user)
      render_success("user #{user} added to group #{name}")
    end
  rescue => e
    render_failure(e.message)
  end

  def remove_user
    name = params[:group_id]
    user = params[:user]

    raise "not authorized" unless is_admin

    if !name || !user
      raise "user or group not set!"
    elsif LDAP::Group.remove_user(name, user)
      render_success("user #{user} removed from group #{name}")
    end
  rescue => e
    render_failure(e.message)
  end

  # POST /groups
  # POST /groups.json
  def create
    name = group_params[:name]

    raise "not authorized" unless is_admin

    if LDAP::Group.create(name)
      render_success("group #{name} created.")
    else
      raise "failed to create group"
    end
  rescue => e
    render_failure(e.message)
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  # def update
  #   respond_to do |format|
  #     if @group.update(group_params)
  #       format.html { redirect_to @group, notice: 'Group was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @group }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @group.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    group = params[:id]
    raise "not authorized" unless is_admin
    if !@group
      raise "group not found"
    elsif LDAP::Group.destroy(group)
      render_success("group #{group} removed")
    end
  rescue => e
    render_failure(e.message)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = LDAP::Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params[:group]
    end
end
