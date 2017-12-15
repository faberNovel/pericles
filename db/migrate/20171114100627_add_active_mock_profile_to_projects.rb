class AddActiveMockProfileToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :mock_profile, foreign_key: true
  end
end
