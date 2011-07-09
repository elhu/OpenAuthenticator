require 'spec_helper'
require 'ruby-debug'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe UsersController do
  render_views

  describe "POST 'create'" do
    before :each do
      @attr = {
        :first_name => "Foo",
        :last_name => "Bar",
        :login => "foobar",
        :email => "foo@bar.com"
      }
    end
    
    it "should fail" do
      @attr[:login] = nil
      lambda do
        post :create, :format => :json, :user => @attr        
      end.should change(User, :count).by(0)
    end
  
    it "should succeed" do
      lambda do
        post :create, :format => :json, :user => @attr
        response.status.should == 201
        response.should contain @attr[:login]
      end.should change(User, :count).by(1)
    end
  end
  
  describe "PUT 'update'" do
    before :each do
      Factory(:user).save
      @attr = {
        :first_name => "Foo_new",
        :last_name => "Bar_new",
        :login => "foobar",
        :email => "foo@bar.com"
      }
    end
    describe "authentication error" do
      it "should return a 401 error when no auth_token is provided" do
        put :update, :format => :json, :id => @attr[:login], :user => @attr
        response.status.should == 401
        response.should contain "false"
      end
    end

    describe "with successful authentication" do
      before :each do
        user_id = 1
        @cookie = PseudoCookie.new
        @cookie.user_id = user_id
        @cookie.expire = Time.new + (10 * 60)
        @cookie.cookie = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}") + user_id.to_s
        @cookie.save!
      end

      describe "failure" do
        it "should not allow access to another user" do
          put :update, :format => :json, :id => "non-existant_id", :user => @attr, :auth_token => @cookie.cookie
          response.status.should == 401
        end

        it "should return a 422 error with a bad arguments" do
          @attr[:last_name] = ""
          put :update, :format => :json, :id => @attr[:login], :user => @attr, :auth_token => @cookie.cookie
          response.status.should == 422
        end
      end
      
      describe "success" do
        it "should succeed with a 200 code" do
          put :update, :format => :json, :id => @attr[:login], :user => @attr, :auth_token => @cookie.cookie
          response.status.should == 200
          response.should contain @attr[:first_name]
        end 
      end
    end
  end

  describe "GET 'show'" do
    before :each do
      @user = Factory(:user)
      @user.save
    end
    
    describe "authentication error" do
      it "should fail with a 401 status" do
        get :show, :format => :json, :id => @user.login
        response.status.should == 401
        response.should contain "false"
      end
    end
    
    describe "use successful authentication" do
      before :each do
        user_id = 1
        @cookie = PseudoCookie.new
        @cookie.user_id = user_id
        @cookie.expire = Time.new + (10 * 60)
        @cookie.cookie = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}") + user_id.to_s
        @cookie.save!
      end
      
      it "should succeed" do
        get :show, :format => :json, :id => @user.login, :auth_token => @cookie.cookie
        response.status.should == 200
        response.should contain @user.login
      end
      
      it "should not allow access to another user" do
        get :show, :format => :json, :id => "invalid_login", :auth_token => @cookie.cookie
        response.status.should == 401
      end
    end
  end

  describe "AJAX verifications" do
    before :each do
      @user = User.new
      Factory(:user).save
    end

    describe "login" do
      it "should fail with a 409 status code" do
        @user.login = "foobar"
        post :check_login, :format => :json, :user => @user
        response.status.should == 409
        response.should contain "false"
      end

      it "should succeed with a 200 status code" do
        @user.login = "test"
        post :check_login, :format => :json, :user => @user
        response.status.should == 200
        response.should contain "true"
      end
    end

    describe "email" do
      it "should fail with a 409 status code" do
        @user.email = "foo@bar.com"
        post :check_email, :format => :json, :user => @user
        response.status.should == 409
        response.should contain "false"
      end

      it "shoud succeed with a 200 status code" do
        @user.email = "test@example.com"
        post :check_email, :format => :json, :user => @user
        response.status.should == 200
        response.should contain "true"
      end
    end
  end
end
