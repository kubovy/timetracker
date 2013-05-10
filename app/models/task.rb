class Task < ActiveRecord::Base
	has_many :logs

  default_scope order('name ASC')

  def destroy
    update! :is_deleted => !self[:is_deleted]
  end
end
