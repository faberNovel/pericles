class CreateSchemes < ActiveRecord::Migration[5.0]
  def change
    create_table :schemes do |t|
      t.string :name
      t.string :regexp

      t.timestamps
    end

    add_reference :attributes, :scheme, foreign_key: true
    reversible do |dir|
      Attribute.find_each do |a|
        dir.up do
          unless a.pattern.blank?
            a.scheme_id = Scheme.find_or_create_by(name: a.pattern, regexp: a.pattern).id
            a.save
          end
        end
        dir.down do
          a.pattern = Scheme.find_by(id: a.scheme_id)&.regexp
          a.save
        end
      end
    end
    # TODO Clément Villain 21/09/17: remove pattern when attributes will use scheme
    # remove_column :attributes, :pattern, :string
  end
end
