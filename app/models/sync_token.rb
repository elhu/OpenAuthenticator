# == Schema Information
#
# Table name: sync_tokens
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  sync_token :string(255)
#  expires_at :string(255)
#  used       :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class SyncToken < ActiveRecord::Base
  # scopes
  scope :current, where(:used => false)

  # model associations
  belongs_to :user

  # before and after filter
  before_create :set_sync_token
  after_create :set_expiring_date

  # Generates the sync_token upon request
  def set_sync_token
    self.sync_token = OaUtils::generate_random_key[0..7]
  end

  # Sets the expiring date of the token at ten minutes after the creation
  def set_expiring_date
    self.expires_at = self.created_at + 10.minutes
    self.save
  end

  # Revokes the token to prevent further use
  def revoke!
    self.used = true
    self.save
  end
end
