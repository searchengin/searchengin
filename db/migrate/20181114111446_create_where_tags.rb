class CreateWhereTags < ActiveRecord::Migration[5.2]
  def change
    create_table :where_tags do |t|
      t.string     :location
      t.text       :description

      t.timestamps
    end
  end
end
