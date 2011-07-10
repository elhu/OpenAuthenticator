# This class defines the API methods related to account_token management
class AccountTokenController < ApplicationController
  before_filter :restricted
  before_filter :get_account_token_and_user, :only => [:show, :update, :destroy]
  before_filter :instanciate_response

  # Lists all the user's account tokens
  #
  # Restricted to: authenticated user, admin
  #
  # Return values;
  # * On success: 200 OK => account tokens
  # * On failure: 404 NOT FOUND => false (no such user)
  #
  # URL params:
  # * <login>: the user the account token belongs to
  # * <format>: the output format wanted
  #
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * GET /users/<login>/account_token
  # * GET /users/<login>/account_token.<format>
  def index
    user = User.find_by_login(params[:user_id])
    success = !user.nil?
    @response.status = success ? :ok : :not_found
    @response.body = success ? user.account_tokens : false
    respond
  end

  # Gets the account token information
  #
  # Restricted to: authenticated user, admin
  #
  # Return values
  # * On success: 200 OK => @account_token
  # * On failure: 404 NOT FOUND => false (no such account token, or account_token not belonging to specified user)
  #
  # URL params:
  # * <login>: the user the account token belongs to
  # * <token_id>: the account_token id
  # * <format>: the output format wanted
  #
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * GET /users/<login>/account_token/<token_id>
  # * GET /users/<login>/account_token/<token_id>.<format>
  def show
    success = !@account_token.nil?
    @response.body = success ? @account_token : false
    @response.status = success ? :ok : :not_found
    respond
  end

  # Creates a new account token for the specified user
  #
  # Restricted to: authenticated user, admin
  #
  # Return values:
  # * On success: 201 CREATED => account_token
  # * On failure:
  #   * 404 NOT FOUND => false (no such user)
  #   * 422 UNPROCESSABLE ENTITY => false (bad parameters)
  #
  # POST Params:
  # * account_token:
  #   * label: label for the account token (string, length <= 255)
  # * auth_token: time-based token generated (string, length == 8)
  #
  # URL Params:
  # * <login>: the user the account token will be created for
  # * <format>: the output format wanted
  #
  # Query URLs:
  # * POST /users/<login>/account_token
  # * POST /users/<login>/account_token.<format>
  def create
    user = User.find_by_login(params[:user_id])
    if user.nil?
      @response.body = false
      @response.status = :not_found
    else
      account_token = user.account_tokens.create(params[:account_token])
      success = account_token.save
      @response.body = success ? account_token : account_token.errors
      @response.status = success ? :created : :unprocessable_entity
    end
    respond
  end

  # Creates a new account token for the specified user
  #
  # Restricted to: authenticated user, admin
  #
  # Return values:
  # * On success: 201 CREATED => account_token
  # * On failure:
  #   * 404 NOT FOUND => false (no such user)
  #   * 422 UNPROCESSABLE ENTITY => false (bad parameters)
  #
  # PUT Params:
  # * account_token:
  #   * label: label for the account token (string, length <= 255)
  # * auth_token: time-based token generated (string, length == 8)
  #
  # URL Params:
  # * <login>: the user the account token will be created for
  # * <format>: the output format wanted
  #
  # Query URLs:
  # * PUT /users/<login>/account_token
  # * PUT /users/<login>/account_token.<format>
  def update
    if @account_token.nil?
      @response.body = false
      @response.status = :not_found
    else
      success = @account_token.update_attributes(params[:account_token])
      @response.body = success ? @account_token : @account_token.errors
      @response.status = success ? :ok : :unprocessable_entity
    end
    respond
  end

  # Deletes (revokes) the specified account token for the specified user
  #
  # Restricted to: authenticated user, admin
  #
  # Return values:
  # * On success: 200 OK => true
  # * On failure: 404 NOT FOUND => false (token not belonging to specified user, no such user or no such token)
  #
  # URL params:
  # * <login>: the user the account token belongs to
  # * <token_id>: the account_token id
  # * <format>: the output format wanted
  #
  # DELETE params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * DELETE /users/<login>/account_token/<token_id>
  # * DELETE /users/<login>/account_token/<token_id>.<format>
  def destroy
    success = !@account_token.nil?
    @response.body = success ? true : false
    @response.status = success ? :ok : :not_found
    @account_token.revoke unless !success
    respond
  end

  def get_account_token_and_user
    @user = User.find_by_login(params[:user_id])
    @account_token = @user.account_tokens.active.find_by_id params[:id]
  end
end
