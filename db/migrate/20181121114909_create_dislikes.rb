class CreateDislikes < ActiveRecord::Migration[5.2]
  def change
    create_table :dislikes do |t|
      t.references :tag, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.references :url, foreign_key: true, index: true

      t.timestamps
    end
  end
end
