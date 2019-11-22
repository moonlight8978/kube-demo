class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uuid, index: { unique: true }

      t.string :full_name
      t.integer :gender

      t.timestamps
    end
  end
end
