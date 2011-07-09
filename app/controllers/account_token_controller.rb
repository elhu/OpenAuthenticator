# This class defines the API methods related to account_token management
class AccountTokenController < ApplicationController
  before_filter :restricted
  
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
    response = HttpResponse.new
    response.status = success ? :ok : :not_found
    response.body = success ? user.account_tokens : false
    respond response
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
    @account_token = AccountToken.find_by_id(params[:id])
    user           = User.find_by_login(params[:user_id])
    success = !(@account_token.nil? or user.nil? or @account_token.user != user or @account_token.state == :revoked.to_s)
    response = HttpResponse.new
    response.body = success ? @account_token : false
    response.status = success ? :ok : :not_found
    respond response
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
    @account_token         = AccountToken.new(params[:account_token])
    user = User.find_by_login(params[:user_id])
    response = HttpResponse.new
    if user.nil?
      response.body = false
      response.staus = :not_found
    else
      @account_token.user_id = user.id
      success = @account_token.save
      response.body = success ? @account_token : @account_token.errors
      response.status = success ? :created : :unprocessable_entity
    end
    respond response
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
    @account_token = AccountToken.find_by_id(params[:id])
    user           = User.find_by_login(params[:user_id])
    response = HttpResponse.new
    if @account_token.nil? or user.nil? or @account_token.user != user
      response.body = false
      response.status = :not_found
    else
      success = @account_token.update_attributes(params[:account_token])
      response.body = success ? @account_token : @account_token.errors
      response.status = success ? :ok : :unprocessable_entity
    end
    respond response
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
    @account_token = AccountToken.find_by_id(params[:id])
    user           = User.find_by_login(params[:user_id])
    success = !(@account_token.nil? or @account_token.state == :revoked.to_s or user.nil? or @account_token.user != user)
    response = HttpResponse.new
    response.body = success ? true : false
    response.status = success ? :ok : :not_found
    @account_token.revoke unless !success
    respond response
  end
end
