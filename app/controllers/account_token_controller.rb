class AccountTokenController < ApplicationController
  def new
  end

  def create
    @account_token = AccountToken.new
    @account_token.user_id = params[:account_token][:user_id]
    @account_token.save
    respond_to do |format|
      format.html { redirect_to @account_token }
    end
  end

  def update
  end

  def delete
  end

  def show
  end

  def index
  end
end
