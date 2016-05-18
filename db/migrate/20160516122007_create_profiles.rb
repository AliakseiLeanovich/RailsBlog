class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.text :description
      t.decimal :lat
      t.decimal :lng
      t.references :user, index: true

      t.timestamps
    end
  end
end
