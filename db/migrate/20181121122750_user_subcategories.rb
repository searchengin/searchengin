class UserSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :user_subcategories, id: false do |t|
      t.references :user, foreign_key: true, index: true
      t.references :subcategory, foreign_key: true, index: true

      t.timestamps
    end

  end
end
