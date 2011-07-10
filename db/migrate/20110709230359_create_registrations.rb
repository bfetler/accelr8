class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.references :accelerator
      t.references :questionnaire

      t.timestamps
    end

    remove_column :questionnaires, :willcode
    add_column :questionnaires, :advisor, :string
  end

  def self.down
    remove_column :questionnaires, :advisor
    add_column :questionnaires, :willcode, :integer
    drop_table :registrations
  end
end
