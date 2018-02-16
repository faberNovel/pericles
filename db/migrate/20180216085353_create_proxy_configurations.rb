class CreateProxyConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :proxy_configurations do |t|
      t.references :project, foreign_key: true, index: true
      t.string :target_base_url, null: false
      t.string :proxy_hostname
      t.integer :proxy_port
      t.string :proxy_username
      t.string :proxy_password
    end

    reversible do |dir|
      dir.up do
        Project.find_each do |p|
          next if p.proxy_url.blank?

          execute(
            "INSERT INTO proxy_configurations (project_id, target_base_url) " +
            "VALUES (#{p.id}, '#{p.proxy_url}');"
          )
        end
      end
    end

    remove_column :projects, :proxy_url, :string
  end
end
