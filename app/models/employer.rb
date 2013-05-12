class Employer < ActiveRecord::Base
	has_many :projects
	has_many :teams
  has_many :employees, :dependent => :destroy
  has_many :users, :through => :employees

  default_scope { order('name ASC') }

  def destroy
    update! :is_deleted => !self[:is_deleted]
  end
end
