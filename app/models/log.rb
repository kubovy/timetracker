class TimingValidator < ActiveModel::Validator
	include TimeHelper

	def validate(record)
		#diff = parse_time(record.finish.strftime("%H:%M")) - parse_time(record.start.strftime("%H:%M"))
		#if diff < 0 or parse_time(record.duration.strftime("%H:%M")) < 0 then
		#	record.errors[:base] << 'Entry finishes before start'
		#end
	end
end

class Log < ActiveRecord::Base
	belongs_to :employer
	belongs_to :team
	belongs_to :project
	belongs_to :task
	belongs_to :user

	validates :employer, :presence => true
	validates :team, :presence => true
	validates :project, :presence => true
	validates :task, :presence => true
	validates :start, :presence => true
	validates :finish, :presence => true
	validates :duration, :presence => true
	validates :description, :presence => true
	validates_with TimingValidator

	def self.duration(finish)
		finish - self.start.hour * 60 * 60 - self.start.min * 60 - self.start.sec
	end

	def finish
		unless self.start.nil? or self.duration.nil? then
			self.start + self.duration.hour * 60 * 60 + self.duration.min * 60 + self.duration.sec
		end
	end
end
