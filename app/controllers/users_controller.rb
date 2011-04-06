class UsersController < ApplicationController
  respond_to :xml, :html, :json, :js
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/login
  # GET /users/login.xml
  def show
    @user = User.find_by_login(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by_login(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    @user.login = params[:user][:login] #needed to secure mass assignment

    respond_to do |format|
      if @user.save
        flash[:success] = 'User was successfully created.';
        format.html { redirect_to @user}
        format.json { render :json => @user }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:error] = 'Something went wrong with the user creation'
        format.html { render :action => "new"}
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find_by_login(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to(@user)}
        format.xml  { head :ok }
      else
        flash[:error] = 'Something went wrong with the user update'
        format.html { render :action => "edit"}
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find_by_login(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # AJAX validation methods
  # check email availability
  def check_email
		user = User.find_by_email(params[:user][:email])
    respond_with(!user)
  end

  # check login availability
  def check_login
  	user = User.find_by_login(params[:user][:login])
		respond_with(!user)
  end
end
