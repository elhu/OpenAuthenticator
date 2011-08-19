# This class defines the API methods relative to SyncToken management
class SyncTokenController < ApplicationController
  before_filter :restricted, :only => [:create]
  before_filter :instanciate_response
  before_filter :get_user

  # Synchronises an account with a device or the website
  #
  # Return values:
  # * On success: 201 CREATED => user
  # * On failure: 422 UNPROCESSABLE ENTITY => false (bad parameters)
  #
  # URL params:
  # * <login>: Login of the user to sync
  # * <sync_token>: token of the sync token used to perform the sync
  # * <format>: Output format wanted
  #
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * GET /users/<login>/sync_token/<sync_token>
  # * GET /users/<login>/sync_token/<sync_token>.format
  def account_sync
    sync_token = @user.sync_tokens.current.find_by_sync_token params[:id]
    if sync_token and not sync_token.used and sync_token.expires_at > DateTime.now
      sync_token.revoke!
      @response.status = :ok
      @response.body = [@user, @user.personal_key]
    else
      @response.status = :unprocessable_entity
      @response.body = false
    end
    respond
  end

  # Generates a sync token
  #
  # Return values:
  # * On success: 200 OK => [user, personal_key] (same as user_create)
  # * On failure: Cannot fail (unless not authenticated)
  #
  # URL params:
  # * <login>: Login of the user to sync
  # * <format>: Output format wanted
  #
  # POST params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * POST /users/<login>/sync_token
  # * POST /users/<login>/sync_token.format
  def create
    prev = @user.sync_tokens.current.first
    prev.revoke! if prev
    sync_token = @user.sync_tokens.create
    @response.status = :created
    @response.body = sync_token
    respond
  end
end
