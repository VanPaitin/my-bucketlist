class Bucketlist < ActiveRecord::Base
  include TimeStamps
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, length: { minimum: 2, maximimu: 20 }
  def self.paginate(page = 1, records = 20)
    offset_parameter = (page - 1) * records
    offset(offset_parameter).limit(records)
  end
end
