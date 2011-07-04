class PersonalKeyController < ApplicationController
  before_filter :restricted
  
  # Lists all the user's personal keys
  #
  # Return values;
  # * On success: 200 OK => personal keys
  # * On failure: 404 NOT FOUND => false (no such user)
  #
  # URL params:
  # * <login>: the user the personal keys belongs to
  # * <format>: the output format wanted
  #
  # Query URLs:
  # GET * /users/<login>/personal_key
  # GET * /users/<login>/personal_key.<format>
  def index
    user = User.find_by_login(params[:user_id])
    respond_to do |format|
      if not user.nil?
        format.json { render :json => user.personal_keys }
      else
        format.json { render :json => false, :status => :not_found}
      end
    end
  end

  # Revokes the active personal key and creates a new one
  #
  # Return values:
  # * On success: 201 CREATED => personal_key
  # * On failure:
  #   * 422 UNPROCESSABLE ENTITY => false (bad parameters)
  #   * 404 NOT FOUND => false (no such user)
  #
  # POST params:
  # * empty parameter set to avoid 411 LENGTH REQUIRED
  #
  # URL params:
  # * <login>: User's login
  # * <format>: Output format wanted
  #
  # Query URLs:
  # * POST /users/<login>/personal_key
  # * POST /users/<login>/personal_key.<format>
  def create
    user = User.find_by_login(params[:user_id])
    PersonalKey.current.find_by_user_id(user.id).revoke unless user.nil? # change to get authenticated user personal_key
    @personal_key = PersonalKey.new
    user = User.find_by_login(params[:user_id])
    @personal_key.user_id = user.id unless user.nil?

    respond_to do |format|
      if not user.nil?
        if @personal_key.save and not user.nil?
          format.json { render :json => @personal_key, :status => :created }
        else
          format.json { render :json => @personal_key.errors, :status => :unprocessable_entity }
        end
      else
        format.json {render :json => false, :status => :not_found }
      end
    end
  end

  # Gets the personal key of the required user
  #
  # Return values:
  # * On success: 200 OK => personal_key
  # * On failure: 404 NOT FOUND => false (no such user, or no such personal_key)
  #
  #
  # URL params:
  # * <login>: User's login
  # * <key_id>: ID of the personal key
  # * <format>: Output format wanted
  #
  # Query URLs:
  # * GET /users/<login>/personal_key/<key_id>
  # * GET /users/<login>/personal_key/<key_id>.<format>
  def show
    @personal_key = PersonalKey.find_by_id params[:id]
    user = User.find_by_login params[:user_id]

    respond_to do |format|
      if @personal_key.nil? or user.nil? or @personal_key.user.id != user.id or @personal_key.state == :revoked.to_s
        format.json { render :json => false, :status => :not_found }
      else
        format.json { render :json => @personal_key }
      end
    end
  end

  # Deletes the specified key
  #
  # Return values:
  # * On success: 200 OK => true
  # * On failure: 404 NOT FOUND => false (no such user, or no such personal_key)
  #
  # URL params:
  # * <login>: User's login
  # * <key_id>: ID of the personal key
  # * <format>: Output format wanted
  #
  # Query URLs:
  # * DELETE /users/<login>/personal_key/<key_id>
  # * DELETE /users/<login>/personal_key/<key_id>.<format>
  def destroy
    @personal_key = PersonalKey.find_by_id params[:id] # change to get authenticated user personal_key
    user = User.find_by_login params[:user_id]

    respond_to do |format|
      if user.nil? or @personal_key.nil? or @personal_key.state == :revoked.to_s or @personal_key.user.id != user.id
        format.json { render :json => false, :status => :not_found }
      else
        @personal_key.revoke
        format.json { render :json => true }
      end
    end
  end
end
