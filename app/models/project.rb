class Project < ActiveRecord::Base
	belongs_to :employer
  belongs_to :owner, :class_name => "User"
	has_many :logs

  default_scope { order('name ASC') }

  def destroy
    update! :is_deleted => !self[:is_deleted]
    end
end
