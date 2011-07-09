module OaUtils
  private
  def self.generate_random_key
    Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}")
  end
end

