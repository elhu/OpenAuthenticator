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
    respond_to do |format|
      if not user.nil?
        format.json { render :json => user.account_tokens }
      else
        format.json { render :json => false, :status => :not_found}
      end
    end
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

    respond_to do |format|
      if @account_token.nil? or user.nil? or @account_token.user != user or @account_token.state == :revoked.to_s
        format.json { render :json => false, :status => :not_found }
      else
        format.json { render :json => @account_token }
      end
    end
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
    @account_token.user_id = params[:user_id]
    user = User.find_by_login(params[:user_id])

    respond_to do |format|
      if user.nil?
        format.json { render :json => false, :status => :not_found }
      else
        @account_token.user_id = user.id
        if @account_token.save
          format.json { render :json => @account_token, :status => :created }
        else
          format.json { render :json => @account_token.errors, :status => :unprocessable_entity }
        end
      end
    end
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

    respond_to do |format|
      if (@account_token.nil? or user.nil? or @account_token.user != user)
        format.json { render :json => false, :status => :not_found }
      else
        if @account_token.update_attributes(params[:account_token])
          format.json { render :json => @account_token }
        else
          format.json { render :json => @account_token.errors, :status => :unprocessable_entity }
        end
      end
    end
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

    respond_to do |format|
      if (@account_token.nil? or @account_token.state == :revoked.to_s or user.nil? or @account_token.user != user)
        format.json { render :json => false, :status => :not_found }
      else
        @account_token.revoke
        format.json { render :json => true }      
      end
    end
  end
end
