class Questionnaire < ActiveRecord::Base
  has_many :ac_registrations, :dependent => :destroy
  has_many :qfounders, :dependent => :destroy
# has_many :qfounders
# belongs_to :user

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

# validates_numericality_of :qfounder_ids, :greater_than => 0
# validates :qfounder_ids, 	:length => { :minimum => 1 }
# validates_presence_of 	:qfounder_ids
# validates_presence_of 	:qfounders
# validates_presence_of 	:qfounders.first
# validates :qfounder_ids, 	:presence => true
# validates :qfounders, 	:presence => true
# validates_associated  :qfounders
# validates_associated  :qfounders,	:presence => :true

# validate :has_a_qfounder

# accepts_nested_attributes_for :qfounders, :allow_destroy => :true,
#     :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
# accepts_nested_attributes_for :ac_registrations, :allow_destroy => :true,
#     :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  def has_a_qfounder
    qs = ''
    qs += qfounders.size.to_s
#   errors.add("Need", " at least one Founder "+qs) if
#     qfounders.count < 1
    if qfounders.size < 1
      errors.add("Need", " at least one Founder "+qs)
    end
  end

  def to_s
    self.companyname
  end
end
