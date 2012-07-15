class Qfounder < ActiveRecord::Base
  belongs_to :questionnaire

  def to_s
    self.firstname + " " + self.lastname
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

  def member_of(qf_array)
#    qf_array contains qfounders w/ other elmts: id, timestamps
    member = qf_array.select { |qf|
      self.firstname == qf.firstname &&
      self.lastname  == qf.lastname &&
      self.role      == qf.role &&
      self.willcode  == qf.willcode &&
      self.weblink   == qf.weblink
    }
    member[0]
  end

# validates :lastname, :presence => true
  validate :has_name

  def has_name
puts "Qfounders has_name: "+self.lastname+", "+self.firstname
    if self.lastname.empty? && self.firstname.empty?
#   if self.to_s == " "
      errors.add("Founder", "has no name")
    end
  end

end
