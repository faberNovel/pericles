class AddInternalToUsers < ActiveRecord::Migration[5.1]
  class User < ActiveRecord::Base
  end

  def up
    add_column :users, :internal, :boolean, default: false

    if ENV['INTERNAL_EMAIL_DOMAIN']
      User.where('email LIKE ?', "%#{ENV['INTERNAL_EMAIL_DOMAIN']}").update_all(internal: true)
    end
  end

  def down
    remove_column :users, :internal
  end
end
