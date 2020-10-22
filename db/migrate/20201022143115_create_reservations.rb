class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :space
      t.belongs_to :user
      t.date :date
      t.boolean :booked
      t.boolean :request
    end
  end
end
