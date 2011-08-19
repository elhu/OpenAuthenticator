# This class defines the API methods related to user management
class UsersController < ApplicationController
  respond_to :xml, :html, :json, :js
  before_filter :restricted, :except => [:index, :create, :check_email, :check_login]
  before_filter :get_user, :only => [:show, :update, :destroy]
  before_filter :instanciate_response

  # Returns all users
  #
  # Restricted to: admin
  #
  # URL params:
  # * <format>: Output format wanted
  #
  # Query URLs:
  # * GET /users
  # * GET /users.<format>
  # ToDo:
  # * Restrict, and probably expect arguments to return a smaller set of users
  def index
    @users = User.all
    @response.status = :ok
    @response.body = @users
    respond
  end

  # Gets user with login <login>
  #
  # Restricted to: authenticated user, admin
  #
  # Return values:
  # * On success: 200 OK => user
  # * On failure: 404 NOT FOUND => false (no such user)
  #
  # URL params:
  # * <login>: User's login
  # * <format>: Output format wanted
  #
  # GET params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * GET /users/<login>
  # * GET /users/<login>.<format>
  def show
    success = !@user.nil?
    @response.body = success ? @user : false
    @response.status = success ? :ok : :not_found
    respond
  end

  # Creates a new User
  #
  # Return values:
  # * On success: 201 CREATED => user
  # * On failure: 422 UNPROCESSABLE ENTITY => false (bad parameters)
  #
  # URL params:
  # * <format>: Output format wanted
  #
  # POST params:
  # * user:
  #   * login: desired login (string, matching: /\w+|[-]/, length: <= 25 )
  #   * first_name: user's first name (string, length: <= 50)
  #   * last_name: user's last name (string, length: <= 50)
  #   * email: user's email address (string, matching: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, length: <= 255)
  #   * birthdate:
  #     * year: user's year of birth (integer)
  #     * month: user's month of birth (integer)
  #     * day: user's day of birth (integer)
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * POST /users
  # * POST /users.<format>
  def create
    user = User.new_with_params params
    success = user.save
    @response.body =  success ? [user, user.personal_key] : user.errors
    @response.status = success ? :created : :unprocessable_entity
    respond
  end

  # Updates user information according to params
  #
  # Restricted to: authenticated user, admin
  #
  # Return values:
  # * On success: 200 OK => user
  # * On failure:
  #   * 422 UNPROCESSABLE ENTITY => false (bad parameters)
  #   * 404 NOT FOUND => false (no such user)
  #
  # URL params:
  # * <format>: Output format wanted
  #
  # PUT Params:
  # * user:
  #   * first_name: user's first name (string, length: <= 50)
  #   * last_name: user's last name (string, length: <= 50)
  #   * email: user's email address (string, matching: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, length: <= 255)
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * PUT /users/<login>
  # * PUT /users/<login>.<format>
  def update
    success = @user.update_attributes(params[:user])
    @response.body = success ? @user : @user.errors
    @response.status = success ? :ok : :unprocessable_entity
    respond
  end

  # Deletes user's record
  #
  # Restricted to: authenticated user, admin
  #
  # Return values:
  # * On success: 200 OK => true
  # * On failure: 404 NOT FOUND => false (no such user)
  #
  # URL params:
  # * <login>: User's login
  # * <format>: Output format wanted
  #
  # DELETE params:
  # * auth_token: time-based token generated (string, length == 8)
  #
  # Query URLs:
  # * DELETE /users/<login>
  # * DELETE /users/<login>.<format>
  def destroy
    success = !@user.nil?
    @user.destroy if success
    @response.body = success ? true : false
    @response.status = success ? :ok : :not_found
    respond
  end

  # AJAX validation methods

  # Checks email availability
  #
  # Return values:
  # * Email available: 200 OK => true
  # * Email unavailable: 409 CONFLICT => false
  #
  # POST Params:
  # * user:
  #   * email: user's email address (string, matching: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, length: <= 255)
  #
  # Query URLs:
  # * POST /users/new/check_email
  def check_email
    user = User.find_by_email(params[:user][:email])
    user_exist_check user
  end

  # Checks login availability
  #
  # Return values:
  # * Login available: 200 OK => true
  # * Login unavailable: 409 CONFLICT => false
  #
  # POST Params:
  # * user:
  #   * login: desired login (string, matching: /\w+|[-]/, length: <= 25 )
  #
  # Query URLs:
  # * POST /users/new/check_login
  def check_login
    user = User.find_by_login(params[:user][:login])
    user_exist_check user
  end

  private
  def user_exist_check user
    @response.body = user ? false : true
    @response.status = user ? :conflict : :ok
    respond
  end

  def get_user
    @user = User.find_by_login(params[:id])
  end
end
