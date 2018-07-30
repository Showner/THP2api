# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :uuid
#
# Indexes
#
#  index_lessons_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

RSpec.describe Lesson, type: :model do
  describe '#validator' do
    subject { create(:lesson) }
    context 'factory is valid' do
      it { is_expected.to be_valid }
      it { expect{ create(:lesson) }.to change{ Lesson.count }.by(1) }
    end

    context ':title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
    end

    context ':description' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_length_of(:description).is_at_most(300) }
    end
  end

  describe '#scope' do
    context ':default_scope' do
      it { expect(Lesson.all.default_scoped.to_sql).to eq Lesson.all.to_sql }
    end
  end

  describe '#relationship' do
    context 'lesson creation' do
      it { is_expected.to belong_to(:creator).class_name(:User) }
      it { is_expected.to belong_to(:creator).inverse_of(:created_lessons) }
      it { is_expected.to belong_to(:creator).counter_cache(:created_lessons_count) }
    end
    xcontext 'follows lesson link' do
    end
  end
end
