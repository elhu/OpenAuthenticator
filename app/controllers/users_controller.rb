# This class defines the API methods related to user management
class UsersController < ApplicationController
  respond_to :xml, :html, :json, :js
  before_filter :restricted, :except => [:index, :create, :check_email, :check_login]

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
    response = HttpResponse.new
    response.status = :ok
    response.body = @users
    respond response
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
    @user = User.find_by_login(params[:id])
    success = !@user.nil?
    response = HttpResponse.new
    response.body = success ? @user : false
    response.status = success ? :ok : :not_found
    respond response
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
    @user           = User.new(params[:user])
    @user.login     = params[:user][:login] #needed to secure mass assignment
    if params[:user][:birthdate] and params[:user][:birthdate][:year] and params[:user][:birthdate][:month] and params[:user][:birthdate][:day]
      @user.birthdate = Date.new(params[:user][:birthdate][:year].to_s.to_i, params[:user][:birthdate][:month].to_s.to_i, params[:user][:birthdate][:day].to_s.to_i)
    end
    response = HttpResponse.new
    success = @user.save
    response.body =  success ? [@user, PersonalKey.current.find_by_user_id(@user.id)] : @user.errors
    response.status = success ? :created : :unprocessable_entity
    respond response
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
    @user = User.find_by_login(params[:id])
    response = HttpResponse.new
    if not @user.nil?
      success = @user.update_attributes(params[:user])
      response.body = success ? @user : @user.errors
      response.status = success ? :ok : :unprocessable_entity
    else
      response.body = false
      response.status = :not_found
    end
    respond response
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
    @user = User.find_by_login(params[:id])
    
    success = !@user.nil?
    @user.destroy if success
    response = HttpResponse.new
    response.body = success ? true : false
    response.status = success ? :ok : :not_found
    respond response
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
    response = HttpResponse.new
    response.body = user ? false : true
    response.status = user ? :conflict : :ok
    respond response
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
    response = HttpResponse.new
    response.body = user ? false : true
    response.status = user ? :conflict : :ok
    respond response
  end
end
