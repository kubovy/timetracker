class Timetable < ActiveRecord::Base
	belongs_to :employer
	belongs_to :user
end
