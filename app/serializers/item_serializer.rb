class ItemSerializer < ActiveModel::Serializer
  include TimeStamps
  attributes :id, :name, :date_created, :date_modified, :done
end
