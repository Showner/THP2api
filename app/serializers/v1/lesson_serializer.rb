# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  title       :string(50)       not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module V1
  class LessonSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :created_at, :updated_at
  end
end
