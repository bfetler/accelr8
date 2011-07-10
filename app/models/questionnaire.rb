class Questionnaire < ActiveRecord::Base
  has_many :registrations, :dependent => :destroy
  has_many :qfounders, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :firstname, :lastname, :email, :companyname, :website, :webvideo, :description, :businessplan, :team, :competition, :other, :invest, :advisor

  validates :companyname, 	:presence => true
  validates :lastname, 		:presence => true
  validates :email, 		:format => { :with => email_regex }
# validates :website, 		:format => /http/
# validates :webvideo, 		:format => /http/
  validates :description, 	:presence => true, 
				:length => { :maximum => 500 }
  validates :businessplan, 	:length => { :maximum => 500 }
  validates :competition, 	:length => { :maximum => 500 }
  validates :team, 		:length => { :maximum => 500 }
  validates :other, 		:length => { :maximum => 500 }
  validates :invest, 		:length => { :maximum => 500 }
  validates :advisor, 		:length => { :maximum => 500 }

  accepts_nested_attributes_for :qfounders, :allow_destroy => :true,
      :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :registrations, :allow_destroy => :true,
      :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  def to_s
    self.companyname
  end
end
