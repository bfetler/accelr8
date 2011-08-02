class Qfounder < ActiveRecord::Base
  belongs_to :questionnaire

# validates :lastname, :presence => true

  def to_s
    self.lastname
  end
end
