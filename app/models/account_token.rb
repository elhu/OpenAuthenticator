# == Schema Information
#
# Table name: account_tokens
#
#  id            :integer         not null, primary key
#  account_token :string(255)
#  state         :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class AccountToken < ActiveRecord::Base
  # model associations
  belongs_to :user

  # prevent foreign key change by mass assignment
  attr_accessible :account_token
end
