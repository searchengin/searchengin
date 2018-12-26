class CreateWhoData < ActiveRecord::Migration[5.2]
  def change
    create_table :who_data do |t|
      t.string     :name, null: false
      t.string     :account
      t.string     :website_url
      t.text       :description
      t.integer    :who_tag_id
      t.integer    :url_id

      t.timestamps
    end
  end
end
