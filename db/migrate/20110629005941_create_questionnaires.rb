class CreateQuestionnaires < ActiveRecord::Migration
  def self.up
    create_table :questionnaires do |t|
      t.string :companyname
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :website
      t.string :webvideo
      t.string :description
      t.string :team
      t.string :businessplan
      t.string :competition
      t.string :other
      t.string :invest
      t.integer :willcode

      t.timestamps
    end
  end

  def self.down
    drop_table :questionnaires
  end
end
