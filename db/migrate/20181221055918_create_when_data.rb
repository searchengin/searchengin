class CreateWhenData < ActiveRecord::Migration[5.2]
  def change
    create_table :when_data do |t|
      t.date       :date
      t.time       :time
      t.text       :description
      t.integer    :when_tag_id

      t.timestamps
    end
  end
end
