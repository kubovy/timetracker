require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am on (.+)$/ do |page_name|
	visit path_to(page_name)
end

Given(/^(.*) employer was selected$/) do |employer|
	employer = '- Select a employer -' if employer == 'No'
	select employer, :from => 'selected_employer_id'
end

When /^I go to (.+)$/ do |page_name|
	visit path_to(page_name)
end

When /^I press "([^"]*)"$/ do |button|
	click_button(button)
end

When /^I click "([^\"]*)"$/ do |link|
	click_link(link)
end

When /^I fill in "([^"]*)" with "([^\"]*)"$/ do |field, value|
	fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I fill in "([^"]*)" for "([^\"]*)"$/ do |value, field|
	fill_in(field.gsub(' ', '_'), :with => value)
end

Then /^I should be on (.+?)$/ do |page_name|
	assert_equal path_to(page_name), current_path
	response.should be_success
end

Then /^I should be redirected to (.+?)$/ do |page_name|
	Then "I should be on #{page_name}"
end


Then(/^I (should|should not) see "(.*?)" menu item$/) do |q,path|
	#path.gsub! /\ \->\ /, ">"
	#path.gsub! /\->/, ">"

	if q == 'should' then
		page.should have_xpath("//nav#{path.split(/ -> /).map{|p|
				"/ul/li//span[contains(text(),'#{p}')]" }.join('/parent::a/parent::li')}")
	else
		page.should_not have_xpath("//nav#{path.split(/ -> /).map{|p|
			"/ul/li//span[contains(text(),'#{p}')]" }.join('/parent::a/parent::li')}")
	end
end