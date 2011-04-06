# == Schema Information
#
# Table name: personal_keys
#
#  id           :integer         not null, primary key
#  personal_key :string(255)
#  state        :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class PersonalKey < ActiveRecord::Base
  # model associations
  belongs_to :user

  scope :current, where(:state => :active)

  # prevent foreign key change by mass assignment
  attr_accessible :personal_key

  # before create filter
  before_create :generate_personal_key


  private
  # generate the personal_key bound to the User
  def generate_personal_key
    self.personal_key = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}")
    self.state = :active
  end

  # revoke the personal key
  def revoke
    self.state = :revoked
  end
end
