# This class defines the API methods related to personal_key management
class PersonalKeyController < ApplicationController
  before_filter :restricted
  before_filter :instanciate_response

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
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # GET * /users/<login>/personal_key
  # GET * /users/<login>/personal_key.<format>
  def index
    user = User.find_by_login(params[:user_id])
    success = !user.nil?
    @response.body = success ? user.personal_keys : false
    @response.status = success ? :ok : :not_found
    respond
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
  # * auth_token: time-based token generated (string, length == 8)
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
    if user.nil?
      @response.body = false
      @response.status = :not_found
    else
      PersonalKey.current.find_by_user_id(user.id).revoke
      personal_key = user.personal_keys.create
      success = personal_key.save
      @response.body = success ? personal_key : personal_key.errors
      @response.status = success ? :created : :unprocessable_entity
    end
    respond
  end

  # Gets the personal key of the required user
  #
  # Return values:
  # * On success: 200 OK => personal_key
  # * On failure: 404 NOT FOUND => false (no such user, or no such personal_key)
  #
  # URL params:
  # * <login>: User's login
  # * <key_id>: ID of the personal key
  # * <format>: Output format wanted
  #
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * GET /users/<login>/personal_key/<key_id>
  # * GET /users/<login>/personal_key/<key_id>.<format>
  def show
    user = User.find_by_login params[:user_id]
    personal_key = user.personal_keys.find_by_id(params[:id]) unless user.nil?
    success = !(personal_key.nil? or personal_key.revoked?)
    @response.body = success ? personal_key : false
    @response.status = success ? :ok : :not_found
    respond
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
  # DELETE params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * DELETE /users/<login>/personal_key/<key_id>
  # * DELETE /users/<login>/personal_key/<key_id>.<format>
  def destroy
    user = User.find_by_login params[:user_id]
    personal_key = user.personal_keys.find_by_id(params[:id]) unless user.nil?
    success = !(personal_key.nil? or personal_key.revoked?)
    @response.body = success ? true : false
    @response.status = success ? :ok : :not_found
    personal_key.revoke if success
    respond
  end
end
