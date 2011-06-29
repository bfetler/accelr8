class CreateQfounders < ActiveRecord::Migration
  def self.up
    create_table :qfounders do |t|
      t.string :firstname
      t.string :lastname
      t.string :role
      t.integer :willcode
      t.string :weblink
      t.references :questionnaire

      t.timestamps
    end
  end

  def self.down
    drop_table :qfounders
  end
end
