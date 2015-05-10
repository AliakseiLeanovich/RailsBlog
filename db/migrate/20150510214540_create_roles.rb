class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :title
      t.text :description
      t.boolean :create_ability
      t.boolean :read_ability
      t.boolean :update_ability
      t.boolean :delete_ability

      t.timestamps
    end
  end
end
