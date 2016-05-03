class User < ActiveRecord::Base
  has_many :bucketlists
  has_secure_password
end
