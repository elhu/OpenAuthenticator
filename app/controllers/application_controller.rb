# This class defines the methods used in several controllers
class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  # Respond with a 422 status code if trying to access a resourcer
  # that doesn't belong to the authenticating user
  def restricted
    if !PseudoCookie.rightful_auth? params
      @response = HttpResponse.new
      @response.body = false
      @response.status = :unauthorized
      respond
    end
  end

  # Instanciates the @response var for all API requests
  def instanciate_response
    @response = HttpResponse.new
  end

  private
  # Handles the response for all API requests
  def respond
    respond_to do |format|
      format.json { render :json => @response.body, :status => @response.status }
      format.xml { render :xml => @response.body, :status => @response.status }
    end
  end
end
