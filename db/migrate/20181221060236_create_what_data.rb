class CreateWhatData < ActiveRecord::Migration[5.2]
  def change
    create_table :what_data do |t|
      t.string     :item_name
      t.string     :category
      t.string     :website_url
      t.text       :description
      t.integer    :what_tag_id

      t.timestamps
    end
  end
end
