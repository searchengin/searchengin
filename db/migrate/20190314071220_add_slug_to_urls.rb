class AddSlugToUrls < ActiveRecord::Migration[5.2]
  def change
    add_column :urls, :slug, :string
    add_index :urls, :slug, unique: true
  end
end
