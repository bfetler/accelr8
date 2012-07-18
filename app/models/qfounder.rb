class Qfounder < ActiveRecord::Base
  belongs_to :questionnaire

  def to_s
    self.firstname + " " + self.lastname
  end

# param utility methods  -  use validations instead?
# def Qfounder.params_any?(paramq)  # paramq = params['qfounder']
#   if !paramq.nil? && paramq.any?
#     paramq.each { |i, fdr|
#       if Qfounder.new(fdr).valid?
#         return true
#       end
#     }
#   end
#   return false
# end

# def Qfounder.has_params?(fdr)  # fdr params
#   fdr.each { |k, v|
#     return true if v != "" && k != "willcode"
#   }
#   return false
# end

  def member_of(qf_array)
#    qf_array contains qfounders w/ db elmts: id, timestamps
    member = qf_array.select { |qf|
      self.firstname == qf.firstname &&
      self.lastname  == qf.lastname &&
      self.role      == qf.role &&
      self.willcode  == qf.willcode &&
      self.weblink   == qf.weblink
    }
    member.first
  end

  validate :has_name

  def has_name
    if self.lastname.empty? && self.firstname.empty?
      errors.add("Founder", "has no name")
    end
  end

end
