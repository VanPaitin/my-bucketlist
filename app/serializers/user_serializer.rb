class UserSerializer < ActiveModel::Serializer
  include TimeStamps
  attributes :id, :name, :email, :date_created, :date_modified
end
