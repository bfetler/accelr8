class AcceleratorUser < ActiveRecord::Base
  has_one :accelerator, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # also :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me

  validates :name, 	:presence => true,
			:uniqueness => true
# seems to validate :email automatically using devise
# validates :email, 	:presence => true,
#			:uniqueness => true
end
