class Team < ActiveRecord::Base
  belongs_to :employer
  has_many :members, :dependent => :destroy
  has_many :users, :through => :members
  has_many :logs

  default_scope order('name ASC')

  def destroy
    update! :is_deleted => !self[:is_deleted]
  end
end
