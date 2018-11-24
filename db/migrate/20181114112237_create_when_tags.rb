class CreateWhenTags < ActiveRecord::Migration[5.2]
  def change
    create_table :when_tags do |t|
      t.date       :date
      t.time       :time
      t.text       :description

      t.timestamps
    end
  end
end
