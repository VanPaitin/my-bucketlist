class User < ActiveRecord::Base
  has_many :bucketlists, dependent: :destroy
  has_secure_password
end
