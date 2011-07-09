# == Schema Information
#
# Table name: users
#
#  id             :integer         not null, primary key
#  login          :string(255)
#  first_name     :string(255)
#  last_name      :string(255)
#  birthdate      :date
#  email          :string(255)
#  emergency_pass :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class User < ActiveRecord::Base  
  # model associations
  has_many :account_tokens, :dependent => :destroy
  has_many :personal_keys, :dependent => :destroy
  has_one :pseudo_cookie, :dependent => :destroy
  
  # forbid mass assignment of login in update.
  attr_accessible :first_name, :last_name, :email, :birth_date

  # regex for format validation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  login_regex = /\w+|[-]/

  # validation rules for User model
  validates :login, :presence => true, :format => { :with => login_regex },
            :length => { :maximum => 25 }, :uniqueness => { :case_sensitive => false }
  validates :first_name, :presence => true, :length => { :maximum => 50 }
  validates :last_name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :format => { :with => email_regex },
            :length => { :maximum => 255 }, :uniqueness => { :case_sensitive => false }

  # before and after filters
  before_create :set_emergency_pass
  after_create :create_personal_key
  
  # returns the active personal_key
  def personal_key
    PersonalKey.current.find_by_user_id(self.id)
  end

  # set the login as key for URLs
  def to_param
    login
  end

  private
  # generate an account_token for the user on create only
  def create_personal_key
    self.personal_keys.create
  end

  # generate and save emergency_pass for the user on create only
  def set_emergency_pass
    self.emergency_pass = OaUtils.generate_random_key if self.new_record? and self.emergency_pass.nil?
  end
end

