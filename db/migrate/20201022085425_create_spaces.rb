class CreateSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :spaces do |t|
      t.belongs_to :user
      t.string :name
      t.string :description
      t.string :price
      t.date :from
      t.date :to
    end
  end
end
