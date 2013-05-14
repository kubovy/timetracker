module TimeHelper

	def parse_time(time)
		return nil unless time.match /^\d{1,2}(:\d{2}){0,2}$/

		time += ':00' if time.match /^\d{1,2}:\d{1,2}$/
		time += ':00:00' if time.match /^\d{1,2}$/
		time = time.split(':').map{|p| p.to_i }
		time = time[0] * 3600 + time[1] * 60 + time[2]
		return time
	end

	def print_time(time)
		"#{pad(time/3600)}:#{pad(time%3600/60)}" #":#{time%3600%60}"
	end

	private

	def pad(num)
		"#{num < 10 ? '0' : ''}#{num}"
	end
end