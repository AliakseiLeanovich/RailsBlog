class AddArticlesGroupsJoinTable < ActiveRecord::Migration
  def change
    create_table :articles_groups, id: false do |t|
      t.integer :article_id
      t.integer :group_id
    end

    add_index :articles_groups, :article_id
    add_index :articles_groups, :group_id
  end
end
