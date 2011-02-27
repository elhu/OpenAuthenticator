class PersonalKeyController < ApplicationController
  def create
    @personal_key = PersonalKey.new
    @personal_key.state = "active"
    @personal_key.save
  end

  def show
  end

  def delete
  end
end
