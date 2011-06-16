require 'spec_helper'

describe AccountTokenController do
  render_views
  before :each do
    @user = Factory(:user)
    @user.save
  end
  
  describe "GET 'index'" do
    describe "success" do
      it "should succeed with a 200 status" do
        get :index, :format => :json, :user_id => @user.login
        response.status.should == 200
      end
    end
    
    describe "failure" do
      it "should fail with a 404 status" do
        get :index, :format => :json, :user_id => "unkown_id"
        response.status.should == 404
      end    
    end
  end
  
  describe "POST 'create'" do
    before :each do
      @account_token = { :label => "test" }  
    end

    describe "success" do      
      it "should succeed with a 201 status" do
        lambda do
          post :create, :format => :json, :user_id => @user.login, :account_token => @account_token
          response.status.should == 201
        end.should change(AccountToken, :count).by(1)
      end
    end
    
    describe "failure" do
      describe "unknow user_id" do
        it "should fail with a 404 status" do
          lambda do
            post :create, :format => :json, :user_id => "unkown_id", :account_token => @account_token
            response.status.should == 404
          end.should change(AccountToken, :count).by(0)
        end
      end

      describe "no label" do
        it "should fail with a 422 status" do
          @account_token[:label] = nil
          lambda do
            post :create, :format => :json, :user_id => @user.login, :account_token => @account_token
            response.status.should == 422
          end.should change(AccountToken, :count).by(0)
        end
      end
    end
  end
  
  describe "GET 'show'" do
    before :each do
      @account_token = Factory(:account_token)
      @account_token.save
    end

    describe "success" do
      it "should succeed with a 200 status" do
        get :show, :format => :json, :user_id => @user.login, :id => @account_token.id
        response.status.should == 200
      end
    end  

    describe "failure" do
      describe "unknow user" do
        it "should fail with a 404 status" do
          get :show, :format => :json, :user_id => "unknow_user", :id => @account_token.id
          response.status.should == 404
        end
      end
      
      describe "unknow account_token id" do
        it "should fail with a 404 status" do
          get :show, :format => :json, :user_id => @user.login, :id => 42
          response.status.should == 404
        end
      end
      
      describe "revoked account_token" do
        it "should fail with a 404 status" do
          @account_token.revoke
          get :show, :format => :json, :user_id => @user.login, :id => @account_token.id
          response.status.should == 404
        end
      end
    end  
  end
  
  describe "PUT 'update'" do
    before :each do
      @base_account_token = Factory(:account_token)
      @base_account_token.save
      @account_token = { :label => "new_label" }
    end
    
    describe "success" do
      it "should succeed with a 200 status and update the label" do
        put :update, :format => :json, :user_id => @user.login, :id => @base_account_token.id, :account_token => @account_token
        response.status.should == 200
        response.should contain @account_token[:label]
      end  
    end
    
    describe "failure" do
      describe "unknow user" do
        it "shoud fail with a 404 status" do
          put :update, :format => :json, :user_id => "Unknown user", :id => @base_account_token.id, :account_token => @account_token
          response.status.should == 404
        end
      end
      
      describe "unknow account_token_id" do
        it "should fail with a 404 status" do
          put :update, :format => :json, :user_id => @user.login, :id => 42, :account_token => @account_token
          response.status.should == 404      
        end
      end
      
      describe "missing label" do
        it "should fail with a 422 status" do
          @account_token[:label] = nil
          put :update, :format => :json, :user_id => @user.login, :id => @base_account_token.id, :account_token => @account_token
          response.status.should == 422
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    before :each do 
      @account_token = Factory(:account_token)
      @account_token.save
    end
    
    describe "success" do
      it "should succeed with a 200 status and NOT reduce the count" do
        lambda do
          delete :destroy, :format => :json, :user_id => @user.login, :id => @account_token.id
          response.status.should == 200
          response.should contain "true"
        end.should change(AccountToken, :count).by(0)
      end
    end
    
    describe "failure" do
      describe "unknow user" do
        it "should fail with a 404 error" do
          delete :destroy, :format => :json, :user_id => "unkown id", :id => @account_token.id
          response.status.should == 404
        end
      end

      describe "unknow account_token id" do
        it "should fail with a 404 error"do 
          delete :destroy, :format => :json, :user_id => @user.login, :id => 42
          response.status.should == 404
        end
      end
    end
  end
end
