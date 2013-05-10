module ApplicationHelper
	def selected_employer
		@selected_employer ||= cookies[:selected_employer_id].nil? ?
			nil : Employer.find(cookies[:selected_employer_id])
	end

	def selected_employer_id
		is_employer_selected? ? selected_employer[:id] : nil
	end

	def is_employer_selected?
		not selected_employer.nil?
	end

	def available_employers
		@available_employers ||= Employer.where :is_deleted => false
	end

	def single_employer?
		@available_employers ||= Employer.where :is_deleted => false
		@available_employers.count == 1
	end

	def button(name, title="")
		content_tag :span, image_tag("#{name}.png") + (title.empty? ? "" : "&nbsp;#{title}".html_safe), :class => "button button-#{name}"
	end
end
