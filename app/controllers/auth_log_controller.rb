# This class defines the API methods related to the logging of Authentication requests
class AuthLogController < ApplicationController
  before_filter :restricted
  before_filter :instanciate_response
  before_filter :get_user

  # Lists all the user's auth attempts
  #
  # Restricted to: authenticated user, admin
  #
  # Return values;
  # * On success: 200 OK => logs
  #
  # URL params:
  # * <login>: the user the logs belongs to
  # * <format>: the output format wanted
  #
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  # * page: Not mandatory, get the 10 logs starting after (page - 1) * 10
  #
  # Query URLs:
  # * GET /users/<login>/auth_log
  # * GET /users/<login>/auth_log.<format>
  def index
    logs = AuthLog.paginate(:include => { :account_token, :user }, :per_page => 10, :page => params[:page],
      :conditions => "users.id = #{@user.id}")
    @response.body = logs
    @response.status = 200
    respond
  end
end
