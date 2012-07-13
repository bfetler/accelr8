class Qfounder < ActiveRecord::Base
  belongs_to :questionnaire

  def to_s
    self.lastname
  end

# param utility methods
# use validations instead?
  def Qfounder.params_any?(paramq)  # paramq = params['qfounder']
    if !paramq.nil? && paramq.any?
      paramq.each { |i, fdr|
#       if Qfounder.is_a_fdr?(fdr)
        if Qfounder.new(fdr).valid?
          return true
        end
      }
    end
    return false
  end

  def Qfounder.is_a_fdr?(fdr)  # fdr - founder params hash
    fdr.each { |j, fval|
# j=='willcode', fval='' or '1'  exclude?
      if fval != ""   # check if any value is non-empty
        return true
      end
    }
    return false
  end

# validates :lastname, :presence => true
  validate :has_name

  def has_name
puts "Qfounders has_name: "+self.lastname+", "+self.firstname
    if self.lastname.empty? && self.firstname.empty?
      errors.add("Founder", " has no name")
    end
  end

end
