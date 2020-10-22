class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.belongs_to :reservation
      t.belongs_to :space
      t.belongs_to :user
    end
  end
end
