class CreateCalculatings < ActiveRecord::Migration[6.0]
  def change
    create_table :calculatings do |t|

      t.timestamps
    end
  end
end
