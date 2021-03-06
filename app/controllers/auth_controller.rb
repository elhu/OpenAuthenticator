# This class defines the API methods related to authentication management
class AuthController < ApplicationController
  respond_to :json, :xml, :html
  before_filter :instanciate_response

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
    credentials = params[:credentials]
    token = credentials[:token]
    account_token = AccountToken.active.find_by_account_token(credentials[:account_token])

    user_id = account_token.user_id
    generated_token = OaUtils.generate_token PersonalKey.current.find_by_user_id(user_id).personal_key
    authorized = generated_token == token ? true : false

    account_token.auth_logs.create!({ :outcome => authorized })

    @response.body = authorized
    @response.status = authorized ? :ok : :unauthorized
    respond
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
    @response.body = Time.new.to_i.to_s
    @response.status = :ok
    respond
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
    credentials = params[:credentials]
    token = credentials[:token]
    personal_key = credentials[:personal_key]

    p_k = PersonalKey.current.find_by_personal_key(personal_key)
    logger.info "p_k: #{p_k.inspect}"

    authorized = OaUtils.generate_token(personal_key) == token ? true : false

    @response.body = (authorized && p_k) ? PseudoCookie.generate_cookie(p_k.user_id) : false
    @response.status = (authorized && p_k) ? :ok : :unauthorized
    respond
  end
end

