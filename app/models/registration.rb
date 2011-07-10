class Registration < ActiveRecord::Base
  belongs_to :accelerator
  belongs_to :questionnaire

  def self.getlastmatch(quid, acid)
    reg = where("questionnaire_id = ? AND accelerator_id = ?", quid.to_s, acid.to_s)
    if (! reg.nil? && reg.any?)
      reg.last.updated_at.to_date().to_s(:db)
    else
      'No'
    end
  end
end
