# == Schema Information
#
# Table name: invitations
#
#  id                :uuid             not null, primary key
#  destination_email :string
#  interest_type     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  emitter_id        :uuid
#  interest_id       :uuid
#  invitee_id        :uuid
#
# Indexes
#
#  index_invitations_on_destination_email              (destination_email)
#  index_invitations_on_emitter_id                     (emitter_id)
#  index_invitations_on_interest_type_and_interest_id  (interest_type,interest_id)
#  index_invitations_on_invitee_id                     (invitee_id)
#
# Foreign Keys
#
#  fk_rails_...  (emitter_id => users.id)
#  fk_rails_...  (invitee_id => users.id)
#

FactoryBot.define do
  factory :invitation do
    trait :with_email do
      destination_email { Faker::Internet.unique.safe_email }
    end
    trait :with_emitter do
      association :emitter, factory: :user
    end

    trait :with_invitee do
      association :invitee, factory: :user
    end

    trait :with_interest do
      association :interest, factory: :course
    end

    trait :with_invalid_interest do
      interest_id { 'sdfrt' }
      interest_type { Course }
    end

    factory :valid_invitation, traits: %i[with_emitter with_invitee]
  end
end
