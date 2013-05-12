module CalendarHelper
	def mini_calendar(selection)
		holidays = Holiday.where :employer_id => selected_employer_id
		date = Date.new selection.year, selection.month, 1
		worked = Hash[Log.select('date, count(date) AS records')
        .where("employer_id = ? AND user_id = ?", selected_employer_id, current_user.id)
		    .group('date').map{ |w|
			[w.date, w.records]
		}]

		prev_month = date.prev_month
		next_month = date.next_month


		while date.wday != wdays[0] do
			date = date.prev_day
		end


		thead = content_tag :thead do
			(content_tag :tr, :class => 'title' do
				concat content_tag(:td,
						(link_to(button(:previous), new_log_path(:date => prev_month)) +
					  "&nbsp;&nbsp;&nbsp;&nbsp;".html_safe +
						"#{I18n.t('date.abbr_month_names')[selection.month]}&nbsp;#{selection.year}".html_safe +
						"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;".html_safe +
						link_to(button(:next), new_log_path(:date => next_month))),
						:colspan => 7)
			end) +
			(content_tag :tr, :class => 'wdays' do
				wdays.each do |day|
					concat content_tag(:td,
							"#{I18n.t('date.abbr_day_names')[day][0]}",
					    :class => ([0,6].include?(day) ? 'weekend' : nil))
				end
			end)
		end


		tbody = content_tag :tbody do
			i = 0
			until date.month == selection.next_month.month do
				row = content_tag :tr do
					while i < wdays.count
						concat content_tag(:td,
								"#{date.month == selection.month ? link_to(date.day, new_log_path(:date => date)) : "&nbsp;"}".html_safe,
						    :class => [
								    (date == selection ? 'selected' : nil),
						        ([0,6].include?(date.wday) ? 'weekend' : nil),
						        (date.month == selection.month ? 'in_month' : nil),
						        (holidays.map{|h| h[:date] == date ? 'holiday' : nil}.compact.first),
						        (date.month == selection.month and worked[date] ? 'worked' : nil),
						        "day"
								].compact.join(" "))
						date = date.next_day
						i += 1
					end
				end
				concat row
				i = 0
			end

			today = content_tag :tr do
				content_tag :td, link_to(button(:today, "Today"), new_log_path(:date => Date.today)), :colspan => 7, :class => 'today'
			end
			concat today

			date = content_tag :tr do
				content_tag :td, selection.strftime('%a, %d. %b %Y'), :colspan => 7, :class => 'date'
			end
			concat date
		end

		content_tag :table, thead.concat(tbody), :class => 'minical'
	end

	private

	def wdays
		(1..6).to_a + [0]
	end
end
