class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :word
      t.text :explain
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
