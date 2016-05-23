class Bucketlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name,
            presence: true,
            length: { minimum: 2, maximum: 40 },
            uniqueness: { case_sensitive: false }
  def self.search(user, query)
    user.bucketlists.where("lower(name) LIKE ?", "%#{query.downcase}%")
  end
end
