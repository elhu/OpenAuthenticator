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

    respond_to do |format|
      format.xml { render :xml => @users }
      format.json { render :json => @users }
    end
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

    respond_to do |format|
      if not @user.nil?
        #format.html # show.html.erb
        format.json
        #format.xml { render :xml => @user }
      else
        format.json { render :json => false, :status => :not_found }
      end
    end
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

    respond_to do |format|
      if @user.save
        format.json { render :json => [@user, PersonalKey.current.find_by_user_id(@user.id)], :status => :created }
      else
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
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

    respond_to do |format|
      if not @user.nil?
        if @user.update_attributes(params[:user])
          #        flash[:success] = 'User was successfully updated.'
          #        format.html { redirect_to(@user)}
          format.json { render :json => @user }
          #        format.xml  { head :ok }
        else
          #        flash[:error] = 'Something went wrong with the user update'
          #        format.html { render :action => "edit"}
          format.json { render :json => @user.errors, :status => :unprocessable_entity }
          #        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      else
        format.json { render :json => false, :status => :not_found }
      end
    end
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
    @user.destroy unless @user.nil?

    respond_to do |format|
      if @user.nil?
#      format.html { redirect_to(users_url) }
#      format.xml  { head :ok }
        format.json { render :json => false, :status => :not_found }
      else
        format.json { render :json => true }
      end
    end
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
    respond_to do |format|
      if user
        format.json { render :json => false, :status => :conflict }
      else
        format.json { render :json => true }        
      end
    end
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
    respond_to do |format|
      if user
        format.json { render :json => false, :status => :conflict }
      else
        format.json { render :json => true }
      end
    end
  end
end
