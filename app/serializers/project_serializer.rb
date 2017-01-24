class ProjectSerializer < ActiveModel::Serializer
  attributes :uuid, :name
  has_and_belongs_to_many :users
end
