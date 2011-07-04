require 'spec_helper'

describe PersonalKeyController do
  before :each do
    @user = Factory :user
    @user.save
    @personal_key = @user.personal_key
  end
  
  describe "GET 'index'" do
    describe "authentication failure" do
      it "should fail with a 401 status" do
        get :index, :format => :json, :user_id => @user.login
        response.status.should == 401
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
      
      describe "success" do
        it "should succeed with a 200 status" do
          get :index, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie
          response.status.should == 200
          response.should contain @personal_key.personal_key
        end
      end
      
      describe "failure" do
        describe "unknow user" do
          it "should fail with a 401 status" do
            get :index, :format => :json, :user_id => "unknown_user", :auth_token => @cookie.cookie
            response.status.should == 401
          end
        end
      end
    end
  end
  
  describe "GET 'show'" do
    describe "authentication failure" do
      it "should fail with a 401 status" do
        get :show, :format => :json, :user_id => @user.login, :id => @personal_key.id
        response.status.should == 401
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

      describe "success" do
        it "should succeed with a 200 status and have the right personal_key" do
          get :show, :format => :json, :user_id => @user.login, :id => @personal_key.id, :auth_token => @cookie.cookie
          response.status.should == 200
          response.should contain @personal_key.personal_key
        end
      end
      
      describe "failure" do
        describe "unknown user" do
          it "should fail with a 401 status" do
            get :show, :format => :json, :user_id => "unknown_user", :id => @personal_key.id, :auth_token => @cookie.cookie
            response.status.should == 401
          end
        end
        
        describe "unknown personal_key" do
          it "should fail with a 404 status" do
            get :show, :format => :json, :user_id => @user.login, :id => 42, :auth_token => @cookie.cookie
            response.status.should == 404
          end
        end
        
        describe "should not show a revoked personel_key" do
          it "should fail with a 404 status" do
            @personal_key.revoke
            get :show, :format => :json, :user_id => @user.login, :id => @personal_key.id, :auth_token => @cookie.cookie
            response.status.should == 404
          end
        end
      end
    end
  end
  
  describe "POST 'create'" do
    describe "authentication failure" do
      it "should fail with a 401 status" do
        post :create, :format => :json, :user_id => @user.login
        response.status.should == 401
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

      describe "success" do
        it "should create a new key and succeed with a 201 status" do
          lambda do
            post :create, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie
            response.status.should == 201
          end.should change(PersonalKey, :count).by(1)
        end
        
        it "should revoke the previous key" do
          post :create, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie
          @personal_key.reload.state.should == :revoked.to_s
        end
      end
      
      describe "failure" do
        describe "unknown user" do
          it "should fail with a 401 status" do
            post :create, :format => :json, :user_id => "Unknown user"
            response.status.should == 401
          end
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    describe "authentication failure" do
      it "should fail with a 401 status" do
        delete :destroy, :format => :json, :user_id => @user.login, :id => @personal_key.id
        response.status.should == 401
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

      describe "success" do
        it "change the key status and succeed with a 200 status" do
          lambda do
            delete :destroy, :format => :json, :user_id => @user.login, :id => @personal_key.id, :auth_token => @cookie.cookie
            response.status.should == 200
            @personal_key.reload.state.should == :revoked.to_s
          end.should change(PersonalKey, :count).by(0)
        end
      end
      
      describe "failure" do
        describe "unkown user" do
          it "should fail with a 401 error" do
            delete :destroy, :format => :json, :user_id => "unknown_user", :id => @personal_key.id, :auth_token => @cookie.cookie
            response.status.should == 401
          end
        end

        describe "unkown personal_key" do
          it "should fail with a 404 error" do
            delete :destroy, :format => :json, :user_id => @user.login, :id => 42, :auth_token => @cookie.cookie
            response.status.should == 404
          end
        end
        
        describe "already revoked key" do
          it "should fail with a 404 error" do
            @personal_key.revoke
            delete :destroy, :format => :json, :user_id => @user.login, :id => @personal_key.id, :auth_token => @cookie.cookie
            response.status.should == 404
          end
        end
      end
    end
  end
end
