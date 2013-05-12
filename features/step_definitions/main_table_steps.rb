
Then(/^I should see "(.*?)" in the (\d+)([^\d]*) column of the main table$/) do |name, column, foo|
	 page.should have_xpath("//body/div[@class='container']/table//tr/td[#{column}][contains(text(), '#{name}')]")
end