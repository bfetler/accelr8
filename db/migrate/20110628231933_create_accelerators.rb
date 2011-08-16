class CreateAccelerators < ActiveRecord::Migration
  def self.up
    create_table :accelerators do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :season
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :website
      t.date :duedate
      t.date :startdate
      t.date :enddate
      t.integer :length
      t.text :description
      t.string :acceptlate
      t.string :acceptapp
      t.string :acceptemail

      t.timestamps
    end
  end

  def self.down
    drop_table :accelerators
  end
end
