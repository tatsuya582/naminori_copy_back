class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum gender: { male: 1, female: 2, other: 3 }, _prefix: true

  validates :first_name, :last_name, :birth_date, :first_name_kana, :last_name_kana, :phone_number, :gender, :prefecture, presence: true
end
