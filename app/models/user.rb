class User < ActiveRecord::Base
	has_many :employees, :dependent => :destroy
  has_many :employers, :through => :employees
  has_many :members, :dependent => :destroy
  has_many :teams, :through => :members

  before_save { self.email = email.downcase unless self.email.nil? }
  before_create :create_remember_token

  default_scope { order('login ASC') }

	def self.cookies=(cookies)
		@cookies = cookies
	end

  def is_admin?
    self[:is_admin]
  end

  def is_manager?
    self[:is_admin] || self[:is_manager]
  end

  def is_manager_of?(what)
    return true if self.is_manager?

    self.employees.each do |employee|
      return true if employee[:is_manager] and [:anything, :any_employer, employee.employer].include?(what)
	    return true if employee[:is_manager] and what == :any_employer_except_selected and employee[:employer_id] != (@cookies.nil? ? 0 : @cookies[:employer_id])
	    return true if employee[:is_manager] and what.is_a?(Employer) and what[:id] == employee[:is_manager]
    end

    return false
  end

  def destroy
    update! :is_deleted => !self[:is_deleted]
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
