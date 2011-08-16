class Accelerator < ActiveRecord::Base
  has_many :ac_registrations, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,	:presence => true
  validates :city,	:presence => true
  validates :state,	:presence => true
  validates :startdate,	:presence => true
  validates :duedate,	:presence => true
  validates :length,	:presence => true
  validates :website,	:format => /http/
  validates :lastname,	:presence => true
  validates :email,	:format => { :with => email_regex }
  validates :description,	:presence => true,
				:length => { :maximum => 300 }
  validates :acceptlate, :length => { :maximum => 100 }
# validates :offer,	:length => { :maximum => 100 }
# validates :equity,	:length => { :maximum => 100 }

  def to_s
    if (self.season.nil? || self.season.empty?)
      self.name
    else
      self.name + " (" + self.season + ")"
    end
  end
end
