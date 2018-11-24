class CreateWhoTags < ActiveRecord::Migration[5.2]
  def change
    create_table :who_tags do |t|
      t.string     :name, null: false
      t.string     :account
      t.string     :website_url
      t.text       :description

      t.timestamps
    end
  end
end
