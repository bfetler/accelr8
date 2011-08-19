class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :ac_registrations do |t|
      t.references :accelerator
      t.references :questionnaire

      t.timestamps
    end
  end

  def self.down
    drop_table :ac_registrations
  end
end
