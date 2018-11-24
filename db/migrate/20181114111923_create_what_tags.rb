class CreateWhatTags < ActiveRecord::Migration[5.2]
  def change
    create_table :what_tags do |t|
      t.string     :item_name
      t.string     :category
      t.string     :website_url
      t.text       :description

      t.timestamps
    end
  end
end
