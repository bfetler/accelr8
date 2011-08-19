class CreateQuestionnaires < ActiveRecord::Migration
  def self.up
    create_table :questionnaires do |t|
      t.string :companyname
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :website
      t.string :webvideo
      t.text :description
      t.text :team
      t.text :businessplan
      t.text :competition
      t.text :other
      t.text :invest
      t.text :advisor

      t.timestamps
    end
  end

  def self.down
    drop_table :questionnaires
  end
end
