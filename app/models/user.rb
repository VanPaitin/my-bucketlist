class User < ActiveRecord::Base
  include TimeStamps
  has_many :bucketlists, dependent: :destroy
  has_secure_password
  validates :name, presence: true, length: { minimum: 6, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
