class User < ActiveRecord::Base
  include TimeStamps
  has_many :bucketlists, dependent: :destroy
  has_secure_password
end
