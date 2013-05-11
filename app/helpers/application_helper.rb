module ApplicationHelper
	def button(name, title="")
		content_tag :span, image_tag("#{name}.png") + (title.empty? ? "" : "&nbsp;#{title}".html_safe), :class => "button button-#{name}"
	end

	def format_time_in_seconds(seconds, negative = true)
		unless seconds.nil? then
			minus = seconds < 0 and negative
			hours = (seconds.abs / 3600).floor
			minutes =  ((seconds.abs - (hours * 3600)) / 60).to_i
			return "#{minus ? '-' : ''}#{hours}:#{minutes}"
		else
			return "0:00"
		end
	end
end
