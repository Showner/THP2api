# == Schema Information
#
# Table name: organizations
#
#  id            :uuid             not null, primary key
#  members_count :integer          default(0)
#  name          :string(50)       not null
#  website       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :uuid
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

FactoryBot.define do
  factory :organization do
    name { Faker::Company.unique.name.first(50) }
    association :creator, factory: :user
  end
end
