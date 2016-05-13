class Bucketlist < ActiveRecord::Base
  include TimeStamps
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, length: { minimum: 2, maximimu: 20 }
  def self.search(user, query)
    query = query.downcase
    user.bucketlists.where("lower(name) LIKE ?", "%#{query}%")
  end
end
