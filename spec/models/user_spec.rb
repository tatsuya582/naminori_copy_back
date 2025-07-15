require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:first_name_kana) }
    it { is_expected.to validate_presence_of(:last_name_kana) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:prefecture) }

    it { is_expected.to define_enum_for(:gender).with_values(male: 1, female: 2, other: 3) }
  end
end
