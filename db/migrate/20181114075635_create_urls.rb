class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string     :url
      t.string     :code
      t.integer    :hits, default: 0
      t.string     :title
      t.text       :description
      t.text       :screenshot
      t.boolean    :is_bot, default: false
      t.string     :protocol
      t.string     :domain
      t.string     :subdomain
      t.integer    :points, default: 0
      t.string     :cover_data
      t.string     :favicon_url
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
