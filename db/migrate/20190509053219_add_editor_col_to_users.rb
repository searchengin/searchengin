class AddEditorColToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :editor, :boolean, default: false
  end
end
