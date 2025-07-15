class AddIndexToJwtDenylist < ActiveRecord::Migration[8.0]
  def change
    add_index :jwt_denylists, :jti, unique: true
  end
end
