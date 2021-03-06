# == Schema Information
#
# Table name: organizations
#
#  id                     :uuid             not null, primary key
#  created_sessions_count :integer          default(0)
#  members_count          :integer          default(0)
#  name                   :string(50)       not null
#  website                :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  creator_id             :uuid
#
# Indexes
#
#  index_organizations_on_creator_id  (creator_id)
#  index_organizations_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :website, :created_at, :updated_at, :creator_id, :members_count,
             :created_sessions_count
  has_many(:members) { object.members.pluck(:id) }
  has_many(:created_sessions) { object.created_sessions.pluck(:id) }

  # def this
  #   binding.pry
  #   false
  # end
end
