class PersonalKeyController < ApplicationController
  def create
    @personal_key = PersonalKey.new
    @personal_key.save
  end

  def show
  end

  def delete
    @personal_key = PersonalKey.active
    @personal_key.revoke
  end
end
