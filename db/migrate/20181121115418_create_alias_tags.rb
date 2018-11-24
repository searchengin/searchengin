class CreateAliasTags < ActiveRecord::Migration[5.2]
  def change
    create_table :alias_tags do |t|
      t.text       :url
      t.string     :code
      t.string     :title
      t.text       :description
      t.references :url, foreign_key: true, index: true

      t.timestamps
    end
  end
end
