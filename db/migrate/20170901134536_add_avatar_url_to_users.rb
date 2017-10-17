class AddAvatarUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_url, :string
  end
end
