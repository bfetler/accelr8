class StringToText < ActiveRecord::Migration
  def self.up
    change_column :accelerators,   :description,	:text
    change_column :questionnaires, :description,	:text
    change_column :questionnaires, :team,		:text
    change_column :questionnaires, :businessplan,	:text
    change_column :questionnaires, :competition,	:text
    change_column :questionnaires, :other,		:text
    change_column :questionnaires, :invest,		:text
    change_column :questionnaires, :advisor,		:text
  end

  def self.down
    change_column :questionnaires, :team,		:string
    change_column :questionnaires, :businessplan,	:string
    change_column :questionnaires, :competition,	:string
    change_column :questionnaires, :other,		:string
    change_column :questionnaires, :invest,		:string
    change_column :questionnaires, :advisor,		:string
    change_column :questionnaires, :description,	:string
    change_column :accelerators,   :description,	:string
  end
end
