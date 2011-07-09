# This class defines the API methods related to authentication management
class AuthController < ApplicationController
  respond_to :json, :xml, :html
  
  # Check credentials the owner of the account_token
  #
  # This is the main API method for 3rd party apps
  # and therefore will need to be optimized.
  #
  # Return values:
  # * On success: 200 OK => true (credentials accepted)
  # * On failure: 401 UNAUTHORIZED => false (credential refused)
  #
  # URL params:
  # * <format>: Output format wanted
  #
  # POST params:
  # * credentials:
  #   * account_token: The account_token the user provided (string)
  #   * token: The time-based token the user provided (string, length == 8)
  #
  # Query URLs:
  # * POST /authenticate
  # * POST /authenticate.<format>
  def authenticate
    account_token = params[:credentials][:account_token] unless params[:credentials][:account_token].blank?
    token = params[:credentials][:token] unless params[:credentials][:token].blank?
    
    authorized = false
    
    user_id = AccountToken.active.find_by_account_token(account_token).user_id
    generated_token = generate_token PersonalKey.current.find_by_user_id(user_id).personal_key
    authorized = true if generated_token == token

    response = HttpResponse.new
    response.body = authorized ? true : false
    response.status = authorized ? :ok : :unauthorized
    respond response
  end
  
  # Returns the server time
  #
  # This method will be used by mobile apps to synchronize with the server
  #
  # Return values:
  # * On success: 200 OK => unix timestamp
  # * On failure: Cannot fail.
  #
  # URL params:
  # * <format>: Output format wanted
  #
  # Query URLs:
  # * GET /sync
  # * GET /sync.<format>
  def sync
    response = HttpResponse.new
    response.body = Time.new.to_i.to_s
    response.status = :ok
    respond response
  end
  
  # Gets a token in order to perform account management operations.
  #
  # This method can be used only by the administration website and the
  # mobile apps. A token is valid for 10 minutes.
  #
  # Return values:
  # * On success: 200 OK => cookie (credentials accepted)
  # * On failure: 401 UNAUTHORIZED => false (credential refused)
  #
  # URL params:
  # * <format>: Output format wanted
  #
  # POST params:
  # * credentials:
  #   * personal_key: The account_token the user provided (string)
  #   * token: The time-based token the user provided (string, length == 8)
  #
  # Query URLs:
  # * POST /session_auth
  # * POST /session_auth.<format>
  def session_auth
    personal_key = params[:credentials][:personal_key] unless params[:credentials][:personal_key].blank?
    token = params[:credentials][:token] unless params[:credentials][:token].blank?
    
    authorized = false
    
    user_id = PersonalKey.current.find_by_personal_key(personal_key).user_id
    generated_token = generate_token personal_key
    if generated_token == token
      cookie = PseudoCookie.generate_cookie user_id
      authorized = true
    end
    
    response = HttpResponse.new
    response.body = authorized ? cookie : false
    response.status = authorized ? :ok : :unauthorized
    respond response
  end
end

