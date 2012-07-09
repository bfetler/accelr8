class Questionnaire < ActiveRecord::Base
  has_many :ac_registrations, :dependent => :destroy
  has_many :qfounders, :dependent => :destroy
  belongs_to :user

  MAXLEN = 500

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :firstname, :lastname, :email, :companyname, :website, :webvideo, :description, :businessplan, :team, :competition, :other, :invest, :advisor

  validates :companyname, 	:presence => true
  validates :lastname, 		:presence => true
  validates :email, 		:format => { :with => email_regex }
# validates :website, 		:format => /http/
# validates :webvideo, 		:format => /http/
  validates :description, 	:presence => true, 
				:length => { :maximum => MAXLEN }
  validates :businessplan, 	:length => { :maximum => MAXLEN }
  validates :competition, 	:length => { :maximum => MAXLEN }
  validates :team, 		:length => { :maximum => MAXLEN }
  validates :other, 		:length => { :maximum => MAXLEN }
  validates :invest, 		:length => { :maximum => MAXLEN }
  validates :advisor, 		:length => { :maximum => MAXLEN }

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

  def Questionnaire.getmaxlen   # used in _form.html.erb view
    return MAXLEN.to_s
  end

  def has_a_qfounder
    qs = ''
    qs += qfounders.size.to_s
#   errors.add("Need", " at least one Founder "+qs) if
#     qfounders.count < 1
#   if qfounders.size < 1
    if self.qfounders.size < 1
#     errors.add("Need", " at least one Founder "+qs)
      errors.add("Need", " at least one Founder")
    end
  end

  def to_s
    self.companyname
  end
end
