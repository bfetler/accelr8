class Accelerator < ActiveRecord::Base
  belongs_to :accelerator_user
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

  validate do
    errors.add(:base, "Application Due Date must be on or before Start Date") unless startdate >= duedate
  end

# validate :duedate_before_startdate

  def duedate_before_startdate
#   errors.add(:base, "Start date must be later than due date") unless 3.between?(4, 5)
#   errors.add(:base, "Start date must be later than due date") unless 4 >= 3
    errors.add(:base, "Application due date must be on or before start date") unless startdate >= duedate
# hmm... unless We will accept late applications?
  end

  def to_s
    if (self.season.nil? || self.season.empty?)
      self.name
    else
      self.name + " (" + self.season + ")"
    end
  end
end
