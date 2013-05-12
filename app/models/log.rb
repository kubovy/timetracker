class Log < ActiveRecord::Base
	belongs_to :employer
	belongs_to :team
	belongs_to :project
	belongs_to :task
	belongs_to :user

	def self.duration(finish)
		finish - self.start.hour * 60 * 60 - self.start.min * 60 - self.start.sec
	end

	def finish
		self.start + self.duration.hour * 60 * 60 + self.duration.min * 60 + self.duration.sec
	end
end
