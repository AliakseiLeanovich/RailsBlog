class AddRatingToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :rating, :integer
  end
end
