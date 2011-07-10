# This module aims at grouping all common utilities needed in OpenAuthenticator
module OaUtils
  private
  def self.generate_random_key
    Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}")
  end

  def self.generate_token(personal_key)
    timespan = 30
    time = Time.new.to_i / timespan
    to_hash = "#{personal_key}--#{time.to_s}"
    token = Digest::SHA2.hexdigest(to_hash)[0..7]
  end
end

