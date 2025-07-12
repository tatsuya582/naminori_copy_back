class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # トークン無効化の判定（今回は常に false = 無効化しない）
  def self.jwt_revoked?(_payload, _user)
    false
  end

  # トークンが使われたときの記録処理（今回は何もしない）
  def self.revoke_jwt(_payload, _user)
    # no-op
  end
end
