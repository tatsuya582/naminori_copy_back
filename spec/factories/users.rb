FactoryBot.define do
  factory :user do
    first_name { "太郎" }
    last_name  { "山田" }
    first_name_kana { "たろう" }
    last_name_kana  { "やまだ" }
    birth_date { Date.new(2000, 1, 1) }
    phone_number { "09012345678" }
    gender { :male }
    prefecture { "東京都" }

    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
